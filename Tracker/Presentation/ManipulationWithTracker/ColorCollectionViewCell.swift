import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static properties
    
    static let identifier = "ColorCollectionViewCell"
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 8.0
        static let borderWidth: CGFloat = 3.0
    }
    
    // MARK: - UI-elements
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    
    // MARK: - Public properties
    
    var color: UIColor? {
        get {
            return colorView.backgroundColor
        }
        set {
            colorView.backgroundColor = newValue
        }
    }
    
    // MARK: - Private properties
    
    private var sizeConstraints: [NSLayoutConstraint] = []
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
        setupViewAndConstraints()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Public methods
    
    func configCell(sizeOfView size: CGFloat) {
        sizeConstraints.forEach { $0.constant = size - 4 * Constants.borderWidth }
        UIView.animate(withDuration: 0.1) {
            self.layoutIfNeeded()
        }
    }
    
    func updateCell(toSelected flag: Bool) {
        let colorWithLowerAlpha = color?.withAlphaComponent(0.5)
        let color = flag ? colorWithLowerAlpha?.cgColor : UIColor.ypWhite.cgColor
        contentView.layer.borderColor = color
    }
    
    // MARK: - Private methods
    
    private func setupContentView() {
        contentView.backgroundColor = .clear
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 1.5 * Constants.cornerRadius
        contentView.layer.borderWidth = Constants.borderWidth
        contentView.layer.borderColor = UIColor.ypWhite.cgColor
    }
    
    private func setupViewAndConstraints() {
        let views = [colorView]
        contentView.addSubviews(views)
        
        sizeConstraints = [
            colorView.widthAnchor.constraint(equalToConstant: 0.0),
            colorView.heightAnchor.constraint(equalToConstant: 0.0)
        ]
               
        NSLayoutConstraint.activate([
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
        NSLayoutConstraint.activate(sizeConstraints)
    }
}
