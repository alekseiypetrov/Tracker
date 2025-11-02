import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "EmojiCollectionViewCell"
    
    private enum Constants {
        static let cornerRadius: CGFloat = 16.0
        static let sizeOfLabel: CGSize = CGSize(width: 32.0, height: 38.0)
        static let fontForLabel = UIFont.boldSystemFont(ofSize: 32.0)
    }
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.fontForLabel
        label.text = ""
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = Constants.cornerRadius
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error in init?(coder:)")
    }
    
    func configCell(with emoji: String) {
        emojiLabel.text = emoji
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
