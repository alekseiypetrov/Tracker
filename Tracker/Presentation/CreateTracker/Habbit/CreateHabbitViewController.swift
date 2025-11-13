import UIKit

final class CreateHabbitViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        enum DataForCollections {
            static let emojies: [String] = [
                "🙂", "😻", "🌺", "🐶", "❤️", "😱",
                "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"
            ]
            static let colors: [UIColor] = [
                UIColor.sectionColor1, UIColor.sectionColor2, UIColor.sectionColor3,
                UIColor.sectionColor4, UIColor.sectionColor5, .sectionColor6,
                UIColor.sectionColor7, UIColor.sectionColor8, UIColor.sectionColor9,
                UIColor.sectionColor10, UIColor.sectionColor11, UIColor.sectionColor12,
                UIColor.sectionColor13, UIColor.sectionColor14, UIColor.sectionColor15,
                UIColor.sectionColor16, UIColor.sectionColor17, UIColor.sectionColor18
            ]
            static let headers: [String] = ["Emoji", "Цвет"]
            static let numberOfElements: Int = 18
            static let numberOfCellsInRow: Int = 6
            static let minimumSizeOfColorCell: CGFloat = 48.0
            static let maximumSizeOfColorCell: CGFloat = 52.0
            static let heightOfHeader: CGFloat = 34.0
            static let sectionEdgeInsets = UIEdgeInsets(top: 24.0, left: 16.0, bottom: 24.0, right: 16.0)
        }
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
        static let maximumLengthOfText = 38
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
        tableView.register(CreateTrackerTableViewCell.self, forCellReuseIdentifier: CreateTrackerTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = Constants.cornerRadiusOfUIElements
        return tableView
    }()
    
    private lazy var сollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .ypWhite
        collectionView.allowsMultipleSelection = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EmojiCollectionViewCell.self,
                                forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier)
        collectionView.register(ColorCollectionViewCell.self,
                                forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
        collectionView.register(HeaderSupplementaryView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderSupplementaryView.identifier)
        return collectionView
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
    private var selectedParameters: [String?] = Array(repeating: nil, count: 3)
    private var selectedColor: UIColor?
    private var selectedCells: [IndexPath?] = Array(repeating: nil, count: 2)
    private let cellTitles = ["Категория", "Расписание"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection: UITraitCollection) in
            self.сollectionView.reloadData()
        }
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
              let emoji = selectedParameters[2],
              let color = selectedColor
        else { return }
        let timetable: [Weekday] = stringTimetable == "Каждый день"
        ? [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        : stringTimetable.split(separator: ", ").map { Weekday.convert(from: String($0)) }
        delegate?.addNewTracker(name: name, color: color, emoji: emoji, timetable: timetable, ofCategory: category)
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
        if currentTextInField.count > Constants.maximumLengthOfText {
            showErrorLabel()
            nameOfTracker.text = String(currentTextInField.prefix(Constants.maximumLengthOfText))
        } else {
            hideErrorLabel()
        }
        activateButton()
    }
    
    // MARK: - Private methods
    
    private func setupViewsAndConstraints() {
        let views = [titleLabel, nameOfTracker, errorLabel, tableView,
                     сollectionView, cancelButton, createTrackerButton]
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
            сollectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16.0),
            сollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            сollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            сollectionView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -16.0),
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
           selectedParameters.allSatisfy( { $0 != nil }),
           selectedColor != nil {
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

extension CreateHabbitViewController: CreateTrackerViewControllerDelegate {
    func updateCell(at index: Int, by description: String) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CreateTrackerTableViewCell else { return }
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
        guard let currentCell = tableView.dequeueReusableCell(withIdentifier: CreateTrackerTableViewCell.identifier, for: indexPath) as? CreateTrackerTableViewCell else {
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
            guard let cell = tableView.cellForRow(at: indexPath) as? CreateTrackerTableViewCell,
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

// MARK: - CreateHabbitViewController + UICollectionViewDataSource

extension CreateHabbitViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Constants.DataForCollections.headers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.DataForCollections.numberOfElements
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var currentCell: UICollectionViewCell
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.identifier, for: indexPath) as? EmojiCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.emoji = Constants.DataForCollections.emojies[indexPath.row]
            let isSelected = (indexPath == selectedCells[indexPath.section])
            cell.updateCell(toSelected: isSelected)
            currentCell = cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath) as? ColorCollectionViewCell else {
                return UICollectionViewCell()
            }
            let size = calculateCellSize(for: collectionView).width
            cell.color = Constants.DataForCollections.colors[indexPath.row]
            cell.configCell(sizeOfView: size)
            let isSelected = (indexPath == selectedCells[indexPath.section])
            cell.updateCell(toSelected: isSelected)
            currentCell = cell
        default:
            currentCell = UICollectionViewCell()
        }
        return currentCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String?
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = HeaderSupplementaryView.identifier
        default:
            id = nil
        }
        
        guard let id else { return UICollectionReusableView() }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: id,
            for: indexPath)
        
        guard let headerSupplementaryView = header as? HeaderSupplementaryView,
              indexPath.section < Constants.DataForCollections.headers.count
        else {
            return header
        }
        headerSupplementaryView.configHeader(withTitle: Constants.DataForCollections.headers[indexPath.section])
        headerSupplementaryView.changeVerticalConstraints(flag: true)
        return headerSupplementaryView
    }
}

// MARK: - CreateHabbitViewController + UICollectionViewFlowLayoutDelegate

extension CreateHabbitViewController: UICollectionViewDelegateFlowLayout {
    private func getPaddingWidth(from width: CGFloat, sizeOfCell cellSize: CGFloat) -> CGFloat {
        return (width - 2 * Constants.DataForCollections.sectionEdgeInsets.left) / CGFloat(Constants.DataForCollections.numberOfCellsInRow) - cellSize
    }
    
    private func calculateCellSize(for collectionView: UICollectionView) -> CGSize {
        let paddingWidth = getPaddingWidth(from: collectionView.frame.width,
                                           sizeOfCell: Constants.DataForCollections.maximumSizeOfColorCell)
        if paddingWidth < 1.0 {
            return CGSize(width: Constants.DataForCollections.minimumSizeOfColorCell,
                          height: Constants.DataForCollections.minimumSizeOfColorCell)
        }
        return CGSize(width: Constants.DataForCollections.maximumSizeOfColorCell,
                      height: Constants.DataForCollections.maximumSizeOfColorCell)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calculateCellSize(for: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let paddingWidth = getPaddingWidth(from: collectionView.frame.width,
                                           sizeOfCell: Constants.DataForCollections.maximumSizeOfColorCell)
        if paddingWidth < 1.0 {
            return 0.0
        }
        return paddingWidth
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.DataForCollections.sectionEdgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: Constants.DataForCollections.heightOfHeader)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        switch indexPath.section {
        case 0:
            guard let currentCell = cell as? EmojiCollectionViewCell else { return }
            currentCell.updateCell(toSelected: true)
            if let oldIndexPath = selectedCells[0],
               let oldCell = collectionView.cellForItem(at: oldIndexPath) as? EmojiCollectionViewCell {
                oldCell.updateCell(toSelected: false)
                collectionView.deselectItem(at: oldIndexPath, animated: false)
            }
            selectedParameters[2] = currentCell.emoji
            selectedCells[0] = indexPath
        case 1:
            guard let currentCell = cell as? ColorCollectionViewCell else { return }
            currentCell.updateCell(toSelected: true)
            if let oldIndexPath = selectedCells[1],
               let oldCell = collectionView.cellForItem(at: oldIndexPath) as? ColorCollectionViewCell {
                oldCell.updateCell(toSelected: false)
                collectionView.deselectItem(at: oldIndexPath, animated: false)
            }
            selectedColor = currentCell.color
            selectedCells[1] = indexPath
        default: return
        }
        activateButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        switch indexPath.section {
        case 0:
            guard let oldCell = cell as? EmojiCollectionViewCell else { return }
            oldCell.updateCell(toSelected: false)
            selectedParameters[2] = nil
            selectedCells[0] = nil
        case 1:
            guard let oldCell = cell as? ColorCollectionViewCell else { return }
            oldCell.updateCell(toSelected: false)
            selectedColor = nil
            selectedCells[1] = nil
        default: return
        }
        activateButton()
    }
}
