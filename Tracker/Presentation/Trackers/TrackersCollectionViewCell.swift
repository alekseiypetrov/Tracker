import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static properties
    
    static let identifier = "trackerCellIdentifier"
   
    // MARK: - Constants
    
    private enum Constants {
        enum Image {
            static let ofButtonWithPlus = UIImage(systemName: "plus.circle.fill",
                                                 withConfiguration: UIImage.SymbolConfiguration(pointSize: Size.ofButton))
            static let ofButtonWithCheckmark = UIImage(systemName: "checkmark.circle.fill",
                                                     withConfiguration: UIImage.SymbolConfiguration(pointSize: Size.ofButton))
            static let ofPin = UIImage(systemName: "pin.fill",
                                          withConfiguration: UIImage.SymbolConfiguration(pointSize: Size.ofPinImage))
        }
        enum CornerRadius {
            static let ofEmojiLabel: CGFloat = 12.0
            static let ofCard: CGFloat = 16.0
        }
        enum Size {
            static let ofPinImage: CGFloat = 12.0
            static let ofEmojiAndPin: CGFloat = 24.0
            static let ofButton: CGFloat = 34.0
        }
        enum Height {
            static let ofCountDaysLabel: CGFloat = 18.0
            static let ofTitleLabel: CGFloat = 34.0
            static let ofCard: CGFloat = 90.0
        }
        static let fontForLabels = UIFont.systemFont(ofSize: textSizeOfLabels, weight: .medium)
        static let textSizeOfLabels: CGFloat = 12.0
        static let colorOfBackgroundColorForEmoji: UIColor = .ypWhite.withAlphaComponent(0.3)
    }
    
    // MARK: - UI-elements
    
    private lazy var cardTracker: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = Constants.CornerRadius.ofCard
        return view
    }()
    
    private lazy var pinTrackerImageView: UIImageView = {
        let imageView = UIImageView(image: Constants.Image.ofPin)
        imageView.tintColor = .white
        imageView.contentMode = .center
        return imageView
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.fontForLabels
        label.textAlignment = .center
        label.backgroundColor = Constants.colorOfBackgroundColorForEmoji
        label.layer.masksToBounds = true
        label.layer.cornerRadius = Constants.CornerRadius.ofEmojiLabel
        return label
    }()
    
    private lazy var titleOfTrackerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = Constants.fontForLabels
        label.textColor = .white
        return label
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.addAction(
            UIAction(handler: { [weak self] _ in
                guard let self else { return }
                self.delegate?.didTappedButtonInTracker(self)
            }),
            for: .touchUpInside)
        button.setImage(Constants.Image.ofButtonWithPlus, for: .normal)
        return button
    }()
    
    private lazy var countDaysLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = Constants.fontForLabels
        label.text = "0 дней"
        return label
    }()
    
    // MARK: - Public properties
    
    weak var delegate: TrackersCollectionViewCellDelegate?
    
    var countDays: String? {
        get {
            return countDaysLabel.text
        }
        set {
            countDaysLabel.text = newValue
        }
    }
    
    var imageForButton: UIImage? {
        get {
            return completeButton.currentImage
        }
        set {
            completeButton.setImage(newValue, for: .normal)
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewsAndConstraintsInCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func configCell(on tracker: Tracker, isPinned: Bool) {
        cardTracker.backgroundColor = tracker.color
        completeButton.tintColor = tracker.color
        emojiLabel.text = tracker.emoji
        pinTrackerImageView.isHidden = isPinned
        
        titleOfTrackerLabel.text = tracker.name
        let constraintRect = CGSize(width: frame.size.width - 24.0,
                                    height: CGFloat.greatestFiniteMagnitude)
        let sizeOfTitleText = tracker.name.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: Constants.fontForLabels],
            context: nil
        )
        let numberOfLines = Int(ceil(sizeOfTitleText.height / titleOfTrackerLabel.font.lineHeight))
        if numberOfLines == 1 {
            titleOfTrackerLabel.text = "\n\(tracker.name)"
        }
    }
    
    // MARK: - Private methods

    private func setupViewsAndConstraintsInCell() {
        let views = [cardTracker, emojiLabel, pinTrackerImageView, titleOfTrackerLabel, countDaysLabel, completeButton]
        contentView.addSubviews(views)
        NSLayoutConstraint.activate([
            cardTracker.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardTracker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardTracker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardTracker.heightAnchor.constraint(equalToConstant: Constants.Height.ofCard),
            emojiLabel.topAnchor.constraint(equalTo: cardTracker.topAnchor, constant: 12.0),
            emojiLabel.leadingAnchor.constraint(equalTo: cardTracker.leadingAnchor, constant: 12.0),
            emojiLabel.heightAnchor.constraint(equalToConstant: Constants.Size.ofEmojiAndPin),
            emojiLabel.widthAnchor.constraint(equalToConstant: Constants.Size.ofEmojiAndPin),
            pinTrackerImageView.topAnchor.constraint(equalTo: emojiLabel.topAnchor),
            pinTrackerImageView.trailingAnchor.constraint(equalTo: cardTracker.trailingAnchor, constant: -4.0),
            pinTrackerImageView.heightAnchor.constraint(equalToConstant: Constants.Size.ofEmojiAndPin),
            pinTrackerImageView.widthAnchor.constraint(equalToConstant: Constants.Size.ofEmojiAndPin),
            titleOfTrackerLabel.bottomAnchor.constraint(equalTo: cardTracker.bottomAnchor, constant: -12.0),
            titleOfTrackerLabel.leadingAnchor.constraint(equalTo: cardTracker.leadingAnchor, constant: 12.0),
            titleOfTrackerLabel.trailingAnchor.constraint(equalTo: cardTracker.trailingAnchor, constant: -12.0),
            titleOfTrackerLabel.heightAnchor.constraint(equalToConstant: Constants.Height.ofTitleLabel),
            completeButton.topAnchor.constraint(equalTo: cardTracker.bottomAnchor, constant: 8.0),
            completeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.0),
            completeButton.heightAnchor.constraint(equalToConstant: Constants.Size.ofButton),
            completeButton.widthAnchor.constraint(equalToConstant: Constants.Size.ofButton),
            countDaysLabel.centerYAnchor.constraint(equalTo: completeButton.centerYAnchor),
            countDaysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.0),
            countDaysLabel.trailingAnchor.constraint(equalTo: completeButton.leadingAnchor, constant: -8.0),
            countDaysLabel.heightAnchor.constraint(equalToConstant: Constants.Height.ofCountDaysLabel),
        ])
    }
}
