import UIKit

final class HeaderSupplementaryView: UICollectionReusableView {
    
    // MARK: - Static properties
    
    static let identifier = "headerOfCollectionView"
    
    // MARK: - Private properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 19.0)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func configHeader(withTitle title: String) {
        titleLabel.text = title
    }
    
    // MARK: - Private methods
    
    private func setupViewAndConstraints() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28.0),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
