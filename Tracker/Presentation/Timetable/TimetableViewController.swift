import UIKit

final class TimetableViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        enum Sizes {
            static let heightOfAcceptButton: CGFloat = 60.0
            static let heightOfCellInTable: CGFloat = 75.0
            static let heightOfTable: CGFloat = 7.0 * heightOfCellInTable
        }
        static let cornerRadiusOfButtonAndTable: CGFloat = 16.0
        static let fontForLabels = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        static let titleForButton = NSAttributedString(
            string: "Готово",
            attributes: [.font: fontForLabels,
                         .foregroundColor: UIColor.ypWhite])
    }
    
    // MARK: - Public properties
    
    weak var delegate: CreateHabbitViewController?
    
    // MARK: - Private properties
    
    private let week: [Day] = (2...7).map { Day(weekday: Weekday(rawValue: $0)) } + [Day(weekday: Weekday(rawValue: 1))]
    private var acceptedDays: [Day] = []
    
    // MARK: - UI-elements
    
    private lazy var timetableLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.textAlignment = .center
        label.font = Constants.fontForLabels
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.layer.cornerRadius = Constants.cornerRadiusOfButtonAndTable
        tableView.allowsSelection = false
        tableView.register(TimetableTableViewCell.self, forCellReuseIdentifier: TimetableTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var acceptButton: UIButton = {
        let button = UIButton()
        button.addAction(UIAction(title: "Готово",
                                  handler: { [weak self] _ in
            guard let self else { return }
            self.acceptTimetable()
        }),
                         for: .touchUpInside)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = Constants.cornerRadiusOfButtonAndTable
        button.setAttributedTitle(Constants.titleForButton, for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsAndConstraints()
    }
    
    // MARK: - Actions
    
    @objc
    private func acceptTimetable() {
        var acceptedDaysInString: String
        if acceptedDays.count == week.count {
            acceptedDaysInString = "Каждый день"
        } else {
            acceptedDays.sort(by: { $0.orderNumber < $1.orderNumber })
            acceptedDaysInString = acceptedDays.map { $0.shortName }.joined(separator: ", ")
        }
        dismiss(animated: true, completion: { [weak self] in
            guard let self else { return }
            self.delegate?.updateCell(at: 1, by: acceptedDaysInString)
        })
    }
    
    // MARK: - Private methods
    
    private func setupViewsAndConstraints() {
        let views = [timetableLabel, tableView, acceptButton]
        view.addSubviews(views)
        view.backgroundColor = .ypWhite
        
        NSLayoutConstraint.activate([
            timetableLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timetableLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timetableLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28.0),
            tableView.topAnchor.constraint(equalTo: timetableLabel.bottomAnchor, constant: 30.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            tableView.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfTable),
            acceptButton.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfAcceptButton),
            acceptButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0),
            acceptButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            acceptButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
        ])
    }
}

// MARK: - TimetableViewController + TimetableTableViewCellDelegate

extension TimetableViewController: TimetableTableViewCellDelegate {
    func add(day fullNameOfDay: String) {
        guard let chosenDay = week.first(where: { $0.fullName == fullNameOfDay }) else { return }
        acceptedDays.append(chosenDay)
    }
    
    func remove(day fullNameOfDay: String) {
        acceptedDays.removeAll(where: { $0.fullName == fullNameOfDay })
    }
}

// MARK: - TimetableViewController + UITableViewDataSource

extension TimetableViewController: UITableViewDataSource {
    private func config(_ cell: TimetableTableViewCell, at indexPath: IndexPath) {
        let day = week[indexPath.row]
        cell.dayLabel.text = day.fullName
        cell.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return week.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentCell = tableView.dequeueReusableCell(withIdentifier: TimetableTableViewCell.identifier, for: indexPath) as? TimetableTableViewCell else {
            return UITableViewCell()
        }
        config(currentCell, at: indexPath)
        return currentCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == week.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: .greatestFiniteMagnitude)
        }
    }
}

// MARK: - TimetableViewController + UITableViewDelegate

extension TimetableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.Sizes.heightOfCellInTable
    }
}
