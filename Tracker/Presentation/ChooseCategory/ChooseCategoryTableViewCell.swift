import UIKit

final class ChooseCategoryTableViewCell: UITableViewCell {
    
    // MARK: - Static properties
    
    static let identifier = "cell"
    
    // MARK: - Constants
    
    private enum Constants {
        static let fontForLabel = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        static let heightOfLabel: CGFloat = 22.0
    }
    
    // MARK: - UI-elements
    
    lazy var titleOfCellLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.fontForLabel
        label.textColor = .ypBlack
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error in init?(coder:)")
    }
    
    // MARK: - Private methods
    
    private func setupViewsAndConstraints() {
        contentView.addSubview(titleOfCellLabel)
        contentView.backgroundColor = .ypBackground
        
        NSLayoutConstraint.activate([
            titleOfCellLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -41.0),
            titleOfCellLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            titleOfCellLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleOfCellLabel.heightAnchor.constraint(equalToConstant: Constants.heightOfLabel),
        ])
    }
}
