import UIKit

final class ChooseCategoryViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        enum Sizes {
            static let heightOfTitle: CGFloat = 22.0
            static let imageViewOfEmptyListSize: CGFloat = 80.0
            static let titleOfEmptyListLabelHeight: CGFloat = 36.0
            static let heightOfCell: CGFloat = 75.0
            static let heightOfButton: CGFloat = 60.0
        }
        enum Fonts {
            static let fontOfLabelUnderImage = UIFont.systemFont(ofSize: 12.0, weight: .medium)
            static let fontOfButtonAndTitle = UIFont.systemFont(ofSize: 16.0, weight: .medium)
            static let fontOfCell = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        }
        static let imageOfEmptyList = UIImage.emptyList
        static let cornerRadius: CGFloat = 16.0
        static let titleForButton = NSAttributedString(string: "Добавить категорию",
                                                       attributes: [.font: Fonts.fontOfButtonAndTitle,
                                                                    .foregroundColor: UIColor.ypWhite])
    }
    
    // MARK: - UI-elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.font = Constants.Fonts.fontOfButtonAndTitle
        return label
    }()
    
    private lazy var imageViewOfEmptyList: UIImageView = {
        UIImageView(image: Constants.imageOfEmptyList)
    }()
    
    private lazy var titleOfEmptyListLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "Привычки и события можно\nобъединить по смыслу"
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.font = Constants.Fonts.fontOfLabelUnderImage
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .ypBackground
        tableView.allowsMultipleSelection = false
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = Constants.cornerRadius
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChooseCategoryTableViewCell.self, forCellReuseIdentifier: ChooseCategoryTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.addCategoryButtonPushed()
        }),
                         for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .ypBlack
        button.setAttributedTitle(Constants.titleForButton, for: .normal)
        return button
    }()
    
    // MARK: - Public properties

    weak var delegate: CreateTrackerViewControllerDelegate?
    
    // MARK: - Private properties
    
    private var viewModel: ChooseCategoryViewModel
    private var selectedCategory: String?
    
    // MARK: - Initializers
    
    init(selectedCategory: String?) {
        self.selectedCategory = selectedCategory
        self.viewModel = ChooseCategoryViewModel(categoryStore: TrackerCategoryStore())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.categoriesBinding = { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.changeHeightOfTable()
                self?.viewModel.updateSelectionStates(selectedCategory: self?.selectedCategory)
            }
        }
        viewModel.updateSelectionStates(selectedCategory: selectedCategory)
        setupViewsAndConstraints()
    }
    
    // MARK: - Actions
    
    private func addCategoryButtonPushed() {
        let newCategoryViewController = NewCategoryViewController()
        newCategoryViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: newCategoryViewController)
        present(navigationController, animated: true)
    }
    
    // MARK: - Private methods
    
    private func setupViewsAndConstraints() {
        let views = [titleLabel, imageViewOfEmptyList, titleOfEmptyListLabel, tableView, addCategoryButton]
        view.addSubviews(views)
        view.backgroundColor = .ypWhite
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28.0),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfTitle),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: addCategoryButton.topAnchor, constant: -8.0),
            tableView.heightAnchor.constraint(equalToConstant: 0.0),
            imageViewOfEmptyList.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageViewOfEmptyList.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20.0),
            imageViewOfEmptyList.heightAnchor.constraint(equalToConstant: Constants.Sizes.imageViewOfEmptyListSize),
            imageViewOfEmptyList.widthAnchor.constraint(equalToConstant: Constants.Sizes.imageViewOfEmptyListSize),
            titleOfEmptyListLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleOfEmptyListLabel.topAnchor.constraint(equalTo: imageViewOfEmptyList.bottomAnchor, constant: 8.0),
            titleOfEmptyListLabel.heightAnchor.constraint(equalToConstant: Constants.Sizes.titleOfEmptyListLabelHeight),
            addCategoryButton.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfButton),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
        ])
        changeHeightOfTable()
    }
    
    private func hideTable() {
        [imageViewOfEmptyList, titleOfEmptyListLabel].forEach { $0.isHidden = false }
        tableView.isHidden = true
    }
    
    private func showTable() {
        [imageViewOfEmptyList, titleOfEmptyListLabel].forEach { $0.isHidden = true }
        tableView.isHidden = false
    }
    
    private func getHeightOfTable() -> CGFloat {
        Constants.Sizes.heightOfCell * CGFloat(viewModel.categories.count)
    }
    
    private func changeHeightOfTable() {
        let heightOfTable = getHeightOfTable()
        let maxHeight = view.safeAreaLayoutGuide.layoutFrame.height - Constants.Sizes.heightOfButton - 28.0
        guard let tableViewHeightConstraint = tableView.constraints.filter({ $0.firstAttribute == .height }).first else { return }
        tableViewHeightConstraint.constant = min(heightOfTable, maxHeight)
        tableView.isScrollEnabled = min(heightOfTable, maxHeight) == maxHeight
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.view.layoutIfNeeded()
        }
    }
    
    private func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Внимание",
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

// MARK: - ChooseCategoryViewController + ChooseCategoryViewControllerDelegate

extension ChooseCategoryViewController: ChooseCategoryViewControllerDelegate {
    func addCategory(withTitle title: String) {
        do {
            try viewModel.addCategory(withTitle: title)
            dismiss(animated: true)
        } catch CoreDataError.duplicatingValue(let message) {
            dismiss(animated: true) { [weak self] in
                self?.showAlert(withMessage: message)
            }
        } catch {
            dismiss(animated: true) { [weak self] in
                self?.showAlert(withMessage: "Возникла непредвиденная ошибка")
            }
        }
    }
}

// MARK: - ChooseCategoryViewController + UITableViewDataSource

extension ChooseCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = viewModel.categories.count
        number == 0 ? hideTable() : showTable()
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentCell = tableView.dequeueReusableCell(withIdentifier: ChooseCategoryTableViewCell.identifier, for: indexPath) as? ChooseCategoryTableViewCell
        else { return UITableViewCell() }
        currentCell.viewModel = viewModel.categories[indexPath.row]
        return currentCell
    }
}

// MARK: - ChooseCategoryViewController + UITableViewDelegate

extension ChooseCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.Sizes.heightOfCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.categories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? ChooseCategoryTableViewCell
        else { return }
        let chosenCategory = viewModel.categories[indexPath.row].title
        cell.viewModel?.setSelected(true)
        dismiss(animated: true, completion: {
            self.delegate?.updateCell(at: 0, by: chosenCategory)
        })
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ChooseCategoryTableViewCell else { return }
        cell.viewModel?.setSelected(false)
    }
}
