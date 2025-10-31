import UIKit

final class CreateHabbitTableViewCell: UITableViewCell {
    
    // MARK: - Static properties
    
    static let identifier = "cell"
    
    // MARK: - Constants
    
    private enum Constants {
        static let heightOfLabel: CGFloat = 22.0
        static let fontForLabel = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        static let sizeOfChevron: CGFloat = 24.0
        static let imageOfChevron = UIImage(named: "chevron")
    }
    
    // MARK: - Private properties
    
    private var hasDescription: Bool = false
    private var centerYConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?
    
    // MARK: - UI-elements
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.fontForLabel
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.fontForLabel
        label.textColor = .ypGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var imageViewOfChevron: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.imageOfChevron
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error in init?(coder:)")
    }
    
    // MARK: - Public methods
    
    func update() {
        if let description = descriptionLabel.text,
           !description.isEmpty {
            showDescriptionLabel()
        } else {
            hideDescriptionLabel()
        }
    }
    
    // MARK: - Pivate methods
    
    private func setupViewsAndConstraints() {
        let views = [titleLabel, imageViewOfChevron]
        contentView.addSubviews(views)
        contentView.backgroundColor = .ypBackground
        
        centerYConstraint = titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        topConstraint = titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.0)
        
        guard let centerYConstraint = centerYConstraint else { return }
        
        NSLayoutConstraint.activate([
            centerYConstraint,
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.heightOfLabel),
            imageViewOfChevron.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageViewOfChevron.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16.0),
            imageViewOfChevron.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            imageViewOfChevron.heightAnchor.constraint(equalToConstant: Constants.sizeOfChevron),
            imageViewOfChevron.widthAnchor.constraint(equalToConstant: Constants.sizeOfChevron),
        ])
    }
    
    private func showDescriptionLabel() {
        guard !hasDescription else { return }
        
        contentView.addSubview(descriptionLabel)
        
        guard let centerYConstraint = centerYConstraint,
              let topConstraint = topConstraint
        else { return }
            
        centerYConstraint.isActive = false
        topConstraint.isActive = true
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14.0),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
        
        hasDescription.toggle()
    }
        
    private func hideDescriptionLabel() {
        guard hasDescription else { return }
        
        contentView.willRemoveSubview(descriptionLabel)
        
        guard let centerYConstraint = centerYConstraint,
              let topConstraint = topConstraint
        else { return }
            
        centerYConstraint.isActive = true
        topConstraint.isActive = false
        
        hasDescription.toggle()
    }
}
