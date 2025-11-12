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
            self.addCategory()
        }),
                         for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .ypBlack
        button.setAttributedTitle(Constants.titleForButton, for: .normal)
        return button
    }()
    
    // MARK: - Public properties
    
    var selectedCategory: String?
    weak var delegate: CreateTrackerViewControllerDelegate?
    
    // MARK: - Private properties
    
    private var tableViewHeightConstraint: NSLayoutConstraint?
    private var categoryStore = TrackerCategoryStore()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsAndConstraints()
    }
    
    // MARK: - Actions
    
    private func addCategory() {
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
        
        let count = categoryStore.getNumberOfCategories()
        let heightOfTable = CGFloat(count) * Constants.Sizes.heightOfCell
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: heightOfTable)
        guard let tableViewHeightConstraint = tableViewHeightConstraint else { return }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28.0),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfTitle),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            tableViewHeightConstraint,
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
    }
    
    private func hideTable() {
        [imageViewOfEmptyList, titleOfEmptyListLabel].forEach { $0.isHidden = false }
        tableView.isHidden = true
    }
    
    private func showTable() {
        [imageViewOfEmptyList, titleOfEmptyListLabel].forEach { $0.isHidden = true }
        tableView.isHidden = false
    }
}

// MARK: - ChooseCategoryViewController + ChooseCategoryViewControllerDelegate

extension ChooseCategoryViewController: ChooseCategoryViewControllerDelegate {
    func addCell(withCategory category: String) {
        categoryStore.addCategory(withTitle: category, handler: { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                let message: String
                if let coreDataError = error as? CoreDataError {
                    message = coreDataError.localizedDescription
                } else {
                    message = "Возникла непредвиденная ошибка"
                }
                let alert = UIAlertController(title: "Внимание",
                                              message: message,
                                              preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel)
                alert.addAction(action)
                self.present(alert, animated: true)
            case .success(let insertedIndex):
                self.tableView.performBatchUpdates {
                    let insertedIndexPath = [IndexPath(item: insertedIndex, section: 0)]
                    self.tableView.insertRows(at: insertedIndexPath, with: .automatic)
                } completion: { [weak self] _ in
                    guard let self else { return }
                    self.updateTableViewHeight()
                }
            }
        })
    }
    
    private func updateTableViewHeight() {
        tableView.layoutIfNeeded()
        let contentHeight = tableView.contentSize.height
        let maxHeight = view.safeAreaLayoutGuide.layoutFrame.height - Constants.Sizes.heightOfButton - 28.0
        
        guard let tableViewHeightConstraint else { return }
        if contentHeight > maxHeight {
            tableView.isScrollEnabled = true
            tableViewHeightConstraint.constant = maxHeight
        } else {
            tableView.isScrollEnabled = false
            tableViewHeightConstraint.constant = contentHeight
        }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - ChooseCategoryViewController + UITableViewDataSource

extension ChooseCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = categoryStore.getNumberOfCategories()
        if number == 0 {
            hideTable()
        } else {
            showTable()
        }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentCell = tableView.dequeueReusableCell(withIdentifier: ChooseCategoryTableViewCell.identifier, for: indexPath) as? ChooseCategoryTableViewCell,
              let currentCategory = categoryStore.object(at: indexPath).title
        else {
            return UITableViewCell()
        }
        let isSelected = selectedCategory == nil ? false : currentCategory == selectedCategory
        currentCell.configCell(in: currentCategory,
                                   isSelected: isSelected)
        return currentCell
    }
}

// MARK: - ChooseCategoryViewController + UITableViewDelegate

extension ChooseCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.Sizes.heightOfCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let number = categoryStore.getNumberOfCategories()
        if indexPath.row == number - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? ChooseCategoryTableViewCell,
              let chosenCategory = categoryStore.object(at: indexPath).title
        else { return }
        cell.showCheckmark()
        dismiss(animated: true, completion: {
            self.delegate?.updateCell(at: 0, by: chosenCategory)
        })
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ChooseCategoryTableViewCell else { return }
        cell.hideCheckmark()
    }
}
