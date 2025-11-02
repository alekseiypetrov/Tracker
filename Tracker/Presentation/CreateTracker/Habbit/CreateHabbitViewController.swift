import UIKit

final class CreateHabbitViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        enum Sizes {
            static let heightOfLabel: CGFloat = 22.0
            static let heightOfCellAndField: CGFloat = 75.0
            static let heightOfTable: CGFloat = 2.0 * heightOfCellAndField
            static let heightOfButton: CGFloat = 60.0
        }
        enum Fonts {
            static let fontForButtonsAndTitle = UIFont.systemFont(ofSize: 16.0, weight: .medium)
            static let fontForCellsAndTextField = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        }
        static let cornerRadiusOfUIElements: CGFloat = 16.0
        static let borderWidth: CGFloat = 1.0
        static let maximumLenghtOfText = 38
    }
    
    // MARK: - UI-elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.textAlignment = .center
        label.font = Constants.Fonts.fontForButtonsAndTitle
        return label
    }()
    
    private lazy var nameOfTracker: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.font = Constants.Fonts.fontForCellsAndTextField
        textField.textColor = .ypBlack
        textField.backgroundColor = .ypBackground
        textField.addTarget(self, action: #selector(textChanged), for: .allEditingEvents)
        textField.layer.masksToBounds = true
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
        
        return textField
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textColor = .ypRed
        label.textAlignment = .center
        label.font = Constants.Fonts.fontForCellsAndTextField
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(CreateHabbitTableViewCell.self, forCellReuseIdentifier: CreateHabbitTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = Constants.cornerRadiusOfUIElements
        return tableView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.cancelOfCreation()
        }),
                         for: .touchUpInside)
        button.setAttributedTitle(NSAttributedString(
            string: "Отменить",
            attributes: [.font: Constants.Fonts.fontForButtonsAndTitle,
                         .foregroundColor: UIColor.ypRed]),
                                  for: .normal)
        button.layer.borderWidth = Constants.borderWidth
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadiusOfUIElements
        return button
    }()
    
    private lazy var createTrackerButton: UIButton = {
        let button = UIButton()
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.createTracker()
        }),
                         for: .touchUpInside)
        button.setAttributedTitle(NSAttributedString(
            string: "Создать",
            attributes: [.font: Constants.Fonts.fontForButtonsAndTitle,
                         .foregroundColor: UIColor.ypWhite]),
                                  for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadiusOfUIElements
        return button
    }()
    
    // MARK: - Public properties
    
    weak var delegate: TrackersViewControllerDelegate?
    
    // MARK: - Private properties
    
    private var constraintsOfErrorLabel: [NSLayoutConstraint] = []
    private var selectedParameters: [String?] = [nil, nil]
    private let cellTitles = ["Категория", "Расписание"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreenTapEvent()
        setupViewsAndConstraints()
    }
    
    // MARK: - Actions
    
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func cancelOfCreation() {
        dismiss(animated: true)
    }
    
    func createTracker() {
        guard let name = nameOfTracker.text,
              let category = selectedParameters[0],
              let stringTimetable = selectedParameters[1],
              let lastId = self.delegate?.getNumberOfTrackers()
        else {
            return
        }
        let timetable: [Weekday] = stringTimetable == "Каждый день"
        ? [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        : stringTimetable.split(separator: ", ").map { Weekday.convert(from: String($0)) }
        dismiss(animated: true, completion: { [weak self] in
            guard let self else { return }
            self.delegate?.addNewTracker(Tracker(
                id: lastId + 1,
                name: name,
                color: .ypRed,
                emoji: "",
                timetable: timetable),
                                         ofCategory: category)
        })
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
    
    // MARK: - Private methods
    
    private func setupViewsAndConstraints() {
        let views = [titleLabel, nameOfTracker, errorLabel, tableView, cancelButton, createTrackerButton]
        view.addSubviews(views)
        view.backgroundColor = .ypWhite
        
        errorLabel.isHidden = true
        constraintsOfErrorLabel = [
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfLabel),
            errorLabel.topAnchor.constraint(equalTo: nameOfTracker.bottomAnchor, constant: 8.0),
        ]
        activateButton()
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28.0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfLabel),
            nameOfTracker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.0),
            nameOfTracker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            nameOfTracker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            nameOfTracker.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfCellAndField),
            tableView.topAnchor.constraint(equalTo: nameOfTracker.bottomAnchor, constant: 24.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            tableView.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfTable),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            cancelButton.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfButton),
            createTrackerButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            createTrackerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            createTrackerButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8.0),
            createTrackerButton.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfButton),
            createTrackerButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
        ])
    }
    
    private func configureScreenTapEvent() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func activateButton() {
        if let inputedText = nameOfTracker.text,
           !inputedText.isEmpty,
           selectedParameters.allSatisfy( { $0 != nil }) {
            createTrackerButton.isEnabled = true
            createTrackerButton.backgroundColor = .ypBlack
        } else {
            createTrackerButton.isEnabled = false
            createTrackerButton.backgroundColor = .ypGray
        }
    }
    
    private func showErrorLabel() {
        errorLabel.isHidden = false
        NSLayoutConstraint.activate(constraintsOfErrorLabel)
        if let tableViewTopConstraint = view.constraints.first(where: {
            $0.firstItem as? UITableView == tableView && $0.firstAttribute == .top
        }) {
            tableViewTopConstraint.constant = 24.0 + Constants.Sizes.heightOfLabel + 8.0
        }
    }
    
    private func hideErrorLabel() {
        errorLabel.isHidden = true
        NSLayoutConstraint.deactivate(constraintsOfErrorLabel)
        if let tableViewTopConstraint = view.constraints.first(where: {
            $0.firstItem as? UITableView == tableView && $0.firstAttribute == .top
        }) {
            tableViewTopConstraint.constant = 24.0
        }
    }
}

// MARK: - CreateHabbitViewController + CreateHabbitViewControllerDelegate

extension CreateHabbitViewController: CreateHabbitViewControllerDelegate {
    func updateCell(at index: Int, by description: String) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CreateHabbitTableViewCell else { return }
        cell.descriptionOfParameter = description
        cell.update()
        selectedParameters[index] = !description.isEmpty ? description : nil
        activateButton()
    }
}

// MARK: - CreateHabbitViewController + UITableViewDataSource

extension CreateHabbitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentCell = tableView.dequeueReusableCell(withIdentifier: CreateHabbitTableViewCell.identifier, for: indexPath) as? CreateHabbitTableViewCell else {
            return UITableViewCell()
        }
        let currentTitle = cellTitles[indexPath.row]
        currentCell.configCell(with: currentTitle)
        return currentCell
    }
}

// MARK: - CreateHabbitViewController + UITableViewDelegate

extension CreateHabbitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.Sizes.heightOfCellAndField
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
            guard let cell = tableView.cellForRow(at: indexPath) as? CreateHabbitTableViewCell,
                  let selectedCategory = cell.descriptionOfParameter else {
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
