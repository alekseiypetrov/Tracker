import UIKit

final class StatisticsTableViewCell: UITableViewCell {
    
    // MARK: - Static properties
    
    static let identifier = "statisticsCellIdentifier"
    
    // MARK: - Constants
    
    private enum Constants {
        enum Sizes {
            static let heightOfTitleLabel: CGFloat = 18.0
            static let heightOfNumbericalLabel: CGFloat = 41.0
            static let heightOfCell: CGFloat = 90.0
        }
        enum Fonts {
            static let fontForNumericalLabel = UIFont.boldSystemFont(ofSize: 34.0)
            static let fontForTitleLabel = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        }
        static let cornerRadius: CGFloat = 16.0
        static let borderWidth: CGFloat = 1.0
    }
    
    // MARK: - UI-elements
    
    private lazy var numericalLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.fontForNumericalLabel
        label.textAlignment = .left
        label.textColor = .ypBlack
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Fonts.fontForTitleLabel
        label.textAlignment = .left
        label.textColor = .ypBlack
        return label
    }()
    
    // MARK: - Layers
    
    private var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.linGradRed, UIColor.linGradGreen, UIColor.linGradBlue].map { $0.cgColor }
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = Constants.cornerRadius
        gradientLayer.masksToBounds = true
        gradientLayer.borderWidth = Constants.borderWidth
        gradientLayer.borderColor = UIColor.clear.cgColor
        return gradientLayer
    }()
    
    private let backgroundLayer: CALayer = {
        let backgroundLayer = CALayer()
        backgroundLayer.backgroundColor = UIColor.ypWhite.cgColor
        backgroundLayer.cornerRadius = Constants.cornerRadius - Constants.borderWidth
        backgroundLayer.masksToBounds = true
        return backgroundLayer
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        registerForTraitChanges([UITraitUserInterfaceStyle.self], handler: { (self: Self, previousTraitCollection: UITraitCollection) in
            self.backgroundLayer.backgroundColor = UIColor.ypWhite.cgColor
        })
        setupContentView()
        setupViewsAndConstraints()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayersFrames()
    }
    
    // MARK: - Public methods
    
    func configCell(withTitle title: String, andNumber number: Int) {
        numericalLabel.text = "\(number)"
        titleLabel.text = title
    }
    
    // MARK: - Private methods
    
    private func updateLayersFrames() {
        let bounds = contentView.bounds
        gradientLayer.frame = CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: Constants.Sizes.heightOfCell)
        backgroundLayer.frame = gradientLayer.bounds.insetBy(
            dx: Constants.borderWidth,
            dy: Constants.borderWidth
        )
    }
    
    private func setupContentView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.addSublayer(backgroundLayer)
    }
    
    private func setupViewsAndConstraints() {
        let views = [numericalLabel, titleLabel]
        contentView.addSubviews(views)
        NSLayoutConstraint.activate([
            numericalLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.0),
            numericalLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.0),
            numericalLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.0),
            numericalLabel.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfNumbericalLabel),
            titleLabel.topAnchor.constraint(equalTo: numericalLabel.bottomAnchor, constant: 7.0),
            titleLabel.leadingAnchor.constraint(equalTo: numericalLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: numericalLabel.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfTitleLabel),
        ])
    }
}
