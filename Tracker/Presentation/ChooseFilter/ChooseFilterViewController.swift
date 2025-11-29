import UIKit

final class ChooseFilterViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        enum Sizes {
            static let heightOfTitle: CGFloat = 22.0
            static let heightOfCell: CGFloat = 75.0
        }
        enum Fonts {
            static let fontOfTitle = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        }
        static let headersOfCells = [
            NSLocalizedString("allTrackersHeader", comment: ""),
            NSLocalizedString("todayTrackersHeader", comment: ""),
            NSLocalizedString("completedTrackersHeader", comment: ""),
            NSLocalizedString("nonCompletedTrackersHeader", comment: ""),
        ]
        static let cornerRadius: CGFloat = 16.0
    }
    
    // MARK: - UI-elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("filterHeader", comment: "")
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.font = Constants.Fonts.fontOfTitle
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .ypBackground
        tableView.allowsMultipleSelection = false
        tableView.isScrollEnabled = false
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = Constants.cornerRadius
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChooseCategoryTableViewCell.self, forCellReuseIdentifier: ChooseCategoryTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Public properties

    weak var delegate: TrackersViewControllerDelegate?
    
    // MARK: - Private properties
    
    private var selectedFilter: Int
    private let keyOfFilter = "selectedFilter"
    
    // MARK: - Initializers
    
    init(delegate: TrackersViewControllerDelegate?) {
        self.delegate = delegate
        self.selectedFilter = UserDefaults.standard.integer(forKey: keyOfFilter)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedFilter = UserDefaults.standard.integer(forKey: keyOfFilter)
        setupViewsAndConstraints()
    }
    
    // MARK: - Private methods
    
    private func setupViewsAndConstraints() {
        let views = [titleLabel, tableView]
        view.addSubviews(views)
        view.backgroundColor = .ypWhite
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28.0),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfTitle),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            tableView.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfCell * 4.0),
        ])
    }
}

// MARK: - ChooseFilterViewController + UITableViewDataSource

extension ChooseFilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Constants.headersOfCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentCell = tableView.dequeueReusableCell(withIdentifier: ChooseCategoryTableViewCell.identifier) as? ChooseCategoryTableViewCell
        else { return UITableViewCell() }
        let title = Constants.headersOfCells[indexPath.row]
        currentCell.configCell(withTitle: title,
                               andState: indexPath.row == selectedFilter && indexPath.row > 1)
        return currentCell
    }
}

// MARK: - ChooseCategoryViewController + UITableViewDelegate

extension ChooseFilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.Sizes.heightOfCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == Constants.headersOfCells.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? ChooseCategoryTableViewCell
        else { return }
        let chosenFilter = indexPath.row
        if chosenFilter > 1 {
            cell.setSelected(true)
        }
        dismiss(animated: true, completion: {
            DispatchQueue.global().async {
                UserDefaults.standard.setValue(chosenFilter, forKey: self.keyOfFilter)
            }
            self.delegate?.updateCollection(by: chosenFilter)
        })
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ChooseCategoryTableViewCell else { return }
        cell.setSelected(false)
    }
}
