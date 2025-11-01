import UIKit

final class HeaderSupplementaryView: UICollectionReusableView {
    
    // MARK: - Static properties
    
    static let identifier = "Header"
    
    // MARK: - Private properties
    
    private let titleLabel = UILabel()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 19.0)
        titleLabel.textColor = .ypBlack
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28.0),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func configHeader(withTitle title: String) {
        titleLabel.text = title
    }
}
