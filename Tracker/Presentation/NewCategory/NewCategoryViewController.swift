import UIKit

final class NewCategoryViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        enum Sizes {
            static let heightOfLabel: CGFloat = 22.0
            static let heightOfField: CGFloat = 75.0
            static let heightOfButton: CGFloat = 60.0
        }
        enum Fonts {
            static let fontForButtonAndTitle = UIFont.systemFont(ofSize: 16.0, weight: .medium)
            static let fontForTextField = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        }
        static let cornerRadiusOfUIElements: CGFloat = 16.0
        static let maximumLenghtOfText: Int = 38
    }
    
    // MARK: - UI-elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая категория"
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.font = Constants.Fonts.fontForButtonAndTitle
        return label
    }()
    
    private lazy var nameOfCategory: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название категории"
        textField.font = Constants.Fonts.fontForTextField
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
        label.font = Constants.Fonts.fontForTextField
        return label
    }()
    
    private lazy var createCategoryButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(
            string: "Готово",
            attributes: [.font: Constants.Fonts.fontForButtonAndTitle,
                         .foregroundColor: UIColor.ypWhite]),
                                  for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.addCategory()
        }),
                         for: .touchUpInside)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadiusOfUIElements
        return button
    }()
    
    // MARK: - Public properties
    
    weak var delegate: ChooseCategoryViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsAndConstraints()
    }
    
    // MARK: - Actions
    
    @objc 
    private func clearText() {
        errorLabel.isHidden = true
        nameOfCategory.text = ""
        disableButtons()
    }
    
    @objc
    private func textChanged() {
        guard let currentTextInField = nameOfCategory.text else { return }
        currentTextInField.isEmpty ? disableButtons() : enableButtons()
        if currentTextInField.count > Constants.maximumLenghtOfText {
            errorLabel.isHidden = false
            nameOfCategory.text = String(currentTextInField.prefix(Constants.maximumLenghtOfText))
        } else {
            errorLabel.isHidden = true
        }
    }
    
    private func addCategory() {
        guard let newCategory = nameOfCategory.text else { return }
        dismiss(animated: true, completion: { [weak self] in
            guard let self else { return }
            self.delegate?.addCell(withCategory: newCategory)
        })
    }
    
    // MARK: - Private methods
    
    private func setupViewsAndConstraints() {
        let views = [titleLabel, nameOfCategory, errorLabel, createCategoryButton]
        view.addSubviews(views)
        view.backgroundColor = .ypWhite
        
        errorLabel.isHidden = true
        disableButtons()
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28.0),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfLabel),
            nameOfCategory.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.0),
            nameOfCategory.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            nameOfCategory.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            nameOfCategory.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfField),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: nameOfCategory.bottomAnchor, constant: 8.0),
            errorLabel.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfLabel),
            createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0),
            createCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            createCategoryButton.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfButton),
        ])
    }
    
    private func disableButtons() {
        nameOfCategory.rightView?.isHidden = true
        createCategoryButton.isEnabled = false
        createCategoryButton.backgroundColor = .ypGray
    }
    
    private func enableButtons() {
        nameOfCategory.rightView?.isHidden = false
        createCategoryButton.isEnabled = true
        createCategoryButton.backgroundColor = .ypBlack
    }
}
