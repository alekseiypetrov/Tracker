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
        static let maximumLenghtOfText = 38
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
        textField.placeholder = "Введите название трекера"
        textField.font = Constants.fontForCellsAndTextField
        textField.textColor = .ypBlack
        textField.backgroundColor = .ypBackground
        textField.addTarget(self, action: #selector(textChanged), for: .allEditingEvents)
        textField.layer.cornerRadius = Constants.cornerRadiusOfUIElements
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.leftViewMode = .always
        
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .ypGray
        clearButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        let rightView = UIView()
        rightView.translatesAutoresizingMaskIntoConstraints = false
        rightView.addSubview(clearButton)
        NSLayoutConstraint.activate([
            rightView.widthAnchor.constraint(equalToConstant: 41.0),
            rightView.heightAnchor.constraint(equalToConstant: 75.0),
            clearButton.widthAnchor.constraint(equalToConstant: 17),
            clearButton.heightAnchor.constraint(equalToConstant: 17),
            clearButton.centerXAnchor.constraint(equalTo: rightView.centerXAnchor),
            clearButton.centerYAnchor.constraint(equalTo: rightView.centerYAnchor),
        ])
        textField.rightView = rightView
        textField.rightViewMode = .whileEditing
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textColor = .ypRed
        label.textAlignment = .center
        label.font = Constants.fontForCellsAndTextField
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.cancelOfCreation()
        }),
                         for: .touchUpInside)
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
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.createTracker()
        }),
                         for: .touchUpInside)
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
    
    private var constraintsOfErrorLabel: [NSLayoutConstraint] = []
    private var haveChoosenParameters = [false, false]
    private let cellTitles = ["Категория", "Расписание"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsAndConstraints()
    }
    
    // MARK: - Private methods
    
    @objc
    private func cancelOfCreation() {
        dismiss(animated: true)
    }
    
    @objc func createTracker() {
        // TODO: - Will be done later (создание трекера заданной категории)
    }
    
    @objc
    private func clearText() {
        nameOfTracker.text = ""
        hideErrorLabel()
        activateButton()
    }
    
    @objc
    private func textChanged() {
        guard let currentTextInField = nameOfTracker.text else { return }
        if currentTextInField.count > Constants.maximumLenghtOfText {
            showErrorLabel()
            nameOfTracker.text = String(currentTextInField.prefix(Constants.maximumLenghtOfText))
        } else {
            hideErrorLabel()
        }
        activateButton()
    }
    
    private func setupViewsAndConstraints() {
        let views = [titleLabel, nameOfTracker, tableView, cancelButton, createTrackerButton]
        view.addSubviews(views)
        view.backgroundColor = .ypWhite
        
        errorLabel.isHidden = true
        constraintsOfErrorLabel = [
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.heightAnchor.constraint(equalToConstant: Constants.heightOfLabel),
            errorLabel.topAnchor.constraint(equalTo: nameOfTracker.bottomAnchor, constant: 8.0),
            errorLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -32.0),
        ]
        activateButton()
        
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
    
    private func activateButton() {
        if let inputedText = nameOfTracker.text,
           !inputedText.isEmpty,
           haveChoosenParameters.allSatisfy( { $0 == true }) {
            createTrackerButton.isEnabled = true
            createTrackerButton.backgroundColor = .ypBlack
        } else {
            createTrackerButton.isEnabled = false
            createTrackerButton.backgroundColor = .ypGray
        }
    }
    
    private func showErrorLabel() {
        errorLabel.isHidden = false
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate(constraintsOfErrorLabel)
    }
    
    private func hideErrorLabel() {
        errorLabel.isHidden = true
        errorLabel.removeFromSuperview()
        NSLayoutConstraint.deactivate(constraintsOfErrorLabel)
    }
}

// MARK: - CreateTrackerViewController + CreateTrackerViewControllerDelegate

extension CreateTrackerViewController: CreateTrackerViewControllerDelegate {
    func updateCell(at index: Int, by description: String) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CreateTrackerTableViewCell else { return }
        cell.descriptionLabel.text = description
        cell.update()
        haveChoosenParameters[index] = !description.isEmpty
        activateButton()
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
            guard let cell = tableView.cellForRow(at: indexPath) as? CreateTrackerTableViewCell,
                  let selectedCategory = cell.descriptionLabel.text else {
                return
            }
            categoryViewController.selectedCategory = selectedCategory
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
