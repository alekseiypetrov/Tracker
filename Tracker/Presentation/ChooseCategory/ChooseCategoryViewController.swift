import UIKit

final class ChooseCategoryViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let imageOfEmptyList = UIImage(named: "empty_list_image")
        static let heightOfTitle: CGFloat = 22.0
        static let imageViewOfEmptyListSize: CGFloat = 80.0
        static let cornerRadius: CGFloat = 16.0
        static let titleOfEmptyListLabelHeight: CGFloat = 36.0
        static let heightOfCell: CGFloat = 75.0
        static let heightOfButton: CGFloat = 60.0
        static let fontOfLabelUnderImage = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        static let fontOfButtonAndTitle = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        static let fontOfCell = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        static let titleForButton = NSAttributedString(string: "Добавить категорию",
                                                       attributes: [.font: fontOfButtonAndTitle,
                                                                    .foregroundColor: UIColor.ypWhite])
    }
    
    // MARK: - UI-elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.font = Constants.fontOfButtonAndTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageViewOfEmptyList: UIImageView = {
        let imageView = UIImageView(image: Constants.imageOfEmptyList)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleOfEmptyListLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "Привычки и события можно\nобъединить по смыслу"
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.font = Constants.fontOfLabelUnderImage
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .ypBackground
        tableView.allowsMultipleSelection = false
        tableView.layer.cornerRadius = Constants.cornerRadius
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChooseCategoryTableViewCell.self, forCellReuseIdentifier: ChooseCategoryTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.addCategory()
        }),
                         for: .touchUpInside)
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .ypBlack
        button.setAttributedTitle(Constants.titleForButton, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Public properties
    
    var selectedCategory: String?
    weak var delegate: CreateHabbitViewControllerDelegate?
    
    // MARK: - Private properties
    
    private var tableViewHeightConstraint: NSLayoutConstraint?
    private var categories: [String] = ["Домашний уют", "Проект разгром"]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsAndConstraints()
    }
    
    // MARK: - Private methods
    
    @objc
    private func addCategory() {
        let newCategoryViewController = NewCategoryViewController()
        newCategoryViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: newCategoryViewController)
        present(navigationController, animated: true)
    }
    
    private func setupViewsAndConstraints() {
        let views = [titleLabel, imageViewOfEmptyList, titleOfEmptyListLabel, tableView, addCategoryButton]
        view.addSubviews(views)
        view.backgroundColor = .ypWhite
        
        let heightOfTable = CGFloat(categories.count) * Constants.heightOfCell
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: heightOfTable)
        guard let tableViewHeightConstraint = tableViewHeightConstraint else { return }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28.0),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.heightOfTitle),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            tableViewHeightConstraint,
            imageViewOfEmptyList.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageViewOfEmptyList.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20.0),
            imageViewOfEmptyList.heightAnchor.constraint(equalToConstant: Constants.imageViewOfEmptyListSize),
            imageViewOfEmptyList.widthAnchor.constraint(equalToConstant: Constants.imageViewOfEmptyListSize),
            titleOfEmptyListLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleOfEmptyListLabel.topAnchor.constraint(equalTo: imageViewOfEmptyList.bottomAnchor, constant: 8.0),
            titleOfEmptyListLabel.heightAnchor.constraint(equalToConstant: Constants.titleOfEmptyListLabelHeight),
            addCategoryButton.heightAnchor.constraint(equalToConstant: Constants.heightOfButton),
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

extension ChooseCategoryViewController: ChooseCategoryViewControllerDelegate {
    func addCell(withCategory category: String) {
        let oldCount = categories.count
        categories.append(category)
        tableView.performBatchUpdates {
            tableView.insertRows(at: [IndexPath(row: oldCount, section: 0)], with: .automatic)
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewHeight()
        }
    }
    
    private func updateTableViewHeight() {
        tableView.layoutIfNeeded()
        let contentHeight = tableView.contentSize.height
        let maxHeight = view.safeAreaLayoutGuide.layoutFrame.height - Constants.heightOfButton - 28.0
        
        guard let tableViewHeightConstraint else { return }
        if contentHeight > maxHeight {
            tableView.isScrollEnabled = true
            tableViewHeightConstraint.constant = maxHeight
        } else {
            tableView.isScrollEnabled = false
            tableViewHeightConstraint.constant = contentHeight
        }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
        }
    }
}

extension ChooseCategoryViewController: UITableViewDataSource {
    private func config(_ cell: ChooseCategoryTableViewCell, at indexPath: IndexPath) {
        let currentCategory = categories[indexPath.row]
        cell.titleOfCellLabel.text = currentCategory
        guard let selectedCategory,
              selectedCategory == currentCategory else {
            cell.imageViewOfCheckmark.isHidden = true
            return
        }
        cell.imageViewOfCheckmark.isHidden = false
        cell.accessoryView?.backgroundColor = cell.backgroundColor
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categories.isEmpty {
            hideTable()
            return 0
        } else {
            showTable()
            return categories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChooseCategoryTableViewCell.identifier, for: indexPath) as? ChooseCategoryTableViewCell else {
            return UITableViewCell()
        }
        config(cell, at: indexPath)
        return cell
    }
}

extension ChooseCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.heightOfCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == categories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? ChooseCategoryTableViewCell else { return }
        cell.imageViewOfCheckmark.isHidden = false
        let chosenCategory = categories[indexPath.row]
        dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            self.delegate?.updateCell(at: 0, by: chosenCategory)
        })
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ChooseCategoryTableViewCell else { return }
        cell.imageViewOfCheckmark.isHidden = true
    }
}
