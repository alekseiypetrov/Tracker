import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static properties
    
    static let identifier = "EmojiCollectionViewCell"
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 16.0
        static let sizeOfLabel: CGSize = CGSize(width: 38.0, height: 38.0)
        static let fontForLabel = UIFont.boldSystemFont(ofSize: 32.0)
    }
    
    // MARK: - UI-elements
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.fontForLabel
        label.text = ""
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Public properties
    
    var emoji: String? {
        get {
            return emojiLabel.text
        } 
        set {
            emojiLabel.text = newValue
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
        setupViewAndConstraints()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Public methods
    
    func updateCell(toSelected flag: Bool) {
        let color: UIColor = flag ? .ypLightGray : .ypWhite
        contentView.backgroundColor = color
    }
    
    // MARK: - Private methods
    
    private func setupContentView() {
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = Constants.cornerRadius
    }
    
    private func setupViewAndConstraints() {
        let views = [emojiLabel]
        contentView.addSubviews(views)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: Constants.sizeOfLabel.width),
            emojiLabel.heightAnchor.constraint(equalToConstant: Constants.sizeOfLabel.height),
        ])
    }
}
