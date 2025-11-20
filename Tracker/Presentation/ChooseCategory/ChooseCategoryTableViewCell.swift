import UIKit

final class ChooseCategoryTableViewCell: UITableViewCell {
    
    // MARK: - Static properties
    
    static let identifier = "categoryCellIdentifier"
    
    // MARK: - Constants
    
    private enum Constants {
        static let fontForLabel = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        static let heightOfLabel: CGFloat = 22.0
        static let sizeOfCheckmark: CGFloat = 24.0
    }
    
    // MARK: - UI-elements
    
    private lazy var titleOfCellLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.fontForLabel
        label.textColor = .ypBlack
        label.textAlignment = .left
        return label
    }()
    
    lazy var imageViewOfCheckmark: UIImageView = {
        UIImageView(image: UIImage(systemName: "checkmark")?
            .withTintColor(.ypBlue, renderingMode: .alwaysOriginal))
    }()
    
    // MARK: - Public properties
    
    var viewModel: ChooseCategoryTableViewCellViewModel? {
        didSet {
            viewModel?.titleBinding = { [weak self] in
                self?.titleOfCellLabel.text = $0
            }
            viewModel?.isSelectedBinding = { [weak self] in
                self?.imageViewOfCheckmark.isHidden = !$0
            }
        }
    }
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewsAndConstraints()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Private methods
    
    private func setupViewsAndConstraints() {
        let views = [titleOfCellLabel, imageViewOfCheckmark]
        contentView.addSubviews(views)
        contentView.backgroundColor = .ypBackground
        accessoryView?.backgroundColor = backgroundColor
        imageViewOfCheckmark.isHidden = true
        
        NSLayoutConstraint.activate([
            titleOfCellLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            titleOfCellLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleOfCellLabel.trailingAnchor.constraint(greaterThanOrEqualTo: imageViewOfCheckmark.leadingAnchor, constant: 1.0),
            titleOfCellLabel.heightAnchor.constraint(equalToConstant: Constants.heightOfLabel),
            imageViewOfCheckmark.centerYAnchor.constraint(equalTo: titleOfCellLabel.centerYAnchor),
            imageViewOfCheckmark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            imageViewOfCheckmark.widthAnchor.constraint(equalToConstant: Constants.sizeOfCheckmark),
            imageViewOfCheckmark.heightAnchor.constraint(equalToConstant: Constants.sizeOfCheckmark),
        ])
    }
}
