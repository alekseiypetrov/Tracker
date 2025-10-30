import UIKit

final class CreateTrackerViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let heightOfLabel: CGFloat = 22.0
        static let heightOfCellAndField: CGFloat = 75.0
        static let heightOfTable: CGFloat = 2.0 * heightOfCellAndField
        static let heightOfButton: CGFloat = 60.0
        static let cornerRadiusOfUIElements: CGFloat = 16.0
        static let borderWidth: CGFloat = 1.0
        static let fontForButtonsAndTitle = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        static let fontForCellsAndTextField = UIFont.systemFont(ofSize: 17.0, weight: .regular)
    }
    
    // MARK: - UI-elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.textAlignment = .center
        label.font = Constants.fontForButtonsAndTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameOfTracker: UITextField = {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.rightViewMode = .always
        textField.placeholder = "Введите название трекера"
        textField.font = Constants.fontForCellsAndTextField
        textField.textColor = .ypBlack
        textField.backgroundColor = .ypBackground
        textField.layer.cornerRadius = Constants.cornerRadiusOfUIElements
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(CreateTrackerTableViewCell.self, forCellReuseIdentifier: CreateTrackerTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = Constants.cornerRadiusOfUIElements
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(
            string: "Отменить",
            attributes: [.font: Constants.fontForButtonsAndTitle,
                         .foregroundColor: UIColor.ypRed]),
                                  for: .normal)
        button.layer.borderWidth = Constants.borderWidth
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.cornerRadius = Constants.cornerRadiusOfUIElements
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var createTrackerButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(
            string: "Создать",
            attributes: [.font: Constants.fontForButtonsAndTitle,
                         .foregroundColor: UIColor.ypWhite]),
                                  for: .normal)
        button.layer.cornerRadius = Constants.cornerRadiusOfUIElements
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Private properties
    
    private let cellTitles = ["Категория", "Расписание"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsAndConstraints()
    }
    
    // MARK: - Private methods
    
    private func setupViewsAndConstraints() {
        let views = [titleLabel, nameOfTracker, tableView, cancelButton, createTrackerButton]
        view.addSubviews(views)
        view.backgroundColor = .ypWhite
        
        disableButton()
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28.0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.heightOfLabel),
            nameOfTracker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.0),
            nameOfTracker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            nameOfTracker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            nameOfTracker.heightAnchor.constraint(equalToConstant: Constants.heightOfCellAndField),
            tableView.topAnchor.constraint(equalTo: nameOfTracker.bottomAnchor, constant: 24.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            tableView.heightAnchor.constraint(equalToConstant: Constants.heightOfTable),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            cancelButton.heightAnchor.constraint(equalToConstant: Constants.heightOfButton),
            createTrackerButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            createTrackerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            createTrackerButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8.0),
            createTrackerButton.heightAnchor.constraint(equalToConstant: Constants.heightOfButton),
            createTrackerButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
        ])
    }
    
    private func disableButton() {
        createTrackerButton.isEnabled = false
        createTrackerButton.backgroundColor = .ypGray
    }
    
    private func enableButton() {
        createTrackerButton.isEnabled = true
        createTrackerButton.backgroundColor = .ypBlack
    }
}

// MARK: - CreateTrackerViewController + CreateTrackerViewControllerDelegate

extension CreateTrackerViewController: CreateTrackerViewControllerDelegate {
    func updateCell(at index: Int, by description: String) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CreateTrackerTableViewCell else { return }
        cell.descriptionLabel.text = description
        cell.update()
    }
}

// MARK: - CreateTrackerViewController + UITableViewDataSource

extension CreateTrackerViewController: UITableViewDataSource {
    private func config(_ cell: CreateTrackerTableViewCell, at indexPath: IndexPath) {
        cell.titleLabel.text = cellTitles[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentCell = tableView.dequeueReusableCell(withIdentifier: CreateTrackerTableViewCell.identifier, for: indexPath) as? CreateTrackerTableViewCell else {
            return UITableViewCell()
        }
        config(currentCell, at: indexPath)
        return currentCell
    }
}

// MARK: - CreateTrackerViewController + UITableViewDelegate

extension CreateTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightOfCellAndField
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == cellTitles.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let categoryViewController = ChooseCategoryViewController()
            categoryViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: categoryViewController)
            present(navigationController, animated: true)
        case 1:
            let timetableViewController = TimetableViewController()
            timetableViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: timetableViewController)
            present(navigationController, animated: true)
        default:
            return
        }
    }
}
