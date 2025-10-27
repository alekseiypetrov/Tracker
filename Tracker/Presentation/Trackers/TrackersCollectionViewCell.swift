import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    static let identifier = "cell"
    
    private enum Image {
        static let ofButtonWithPlus = UIImage(systemName: "plus.circle.fill",
                                             withConfiguration: UIImage.SymbolConfiguration(pointSize: Size.ofButton))
        static let ofButtonWithCheckmark = UIImage(systemName: "checkmark.circle.fill",
                                                 withConfiguration: UIImage.SymbolConfiguration(pointSize: Size.ofButton))
        static let ofPin = UIImage(systemName: "pin.fill",
                                      withConfiguration: UIImage.SymbolConfiguration(pointSize: Size.ofPinImage))
    }
    
    private enum Color {
        static let ofBackgroundColorForEmoji: UIColor = .ypWhite.withAlphaComponent(0.3)
    }
    
    private enum CornerRadius {
        static let ofEmojiLabel: CGFloat = 12.0
        static let ofCard: CGFloat = 16.0
    }
    
    private enum Size {
        static let ofPinImage: CGFloat = 12.0
        static let ofEmojiAndPin: CGFloat = 24.0
        static let ofButton: CGFloat = 34.0
    }
    
    private enum Height {
        static let ofCountDaysLabel: CGFloat = 18.0
        static let ofTitleLabel: CGFloat = 34.0
        static let ofCard: CGFloat = 90.0
    }
    
    private enum TextSize {
        static let ofLabels: CGFloat = 12.0
    }
    
    private enum Constraints {
        static let topAnchorConstaintValue: CGFloat = 12.0
        static let topAnchorConstraintOfButtonValue: CGFloat = 8.0
        static let leadingAnchorConstraintValue: CGFloat = 12.0
        static let trailingAnchorConstraintOfPinValue: CGFloat = -4.0
        static let trailingAnchorConstraintValue: CGFloat = -12.0
        static let bottomAnchorConstraintValue: CGFloat = -12.0
        static let bottomAnchorConstraintOfButtonValue: CGFloat = -16.0
        static let distanceBetweenLabelAndButton: CGFloat = -8.0
    }
    
    let cardTracker = UIView()
    let pinTrackerImageView = UIImageView(image: Image.ofPin)
    let emojiLabel = UILabel()
    let titleOfTrackerLabel = UILabel()
    let completeButton = UIButton()
    let countDaysLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        let views = [cardTracker, emojiLabel, pinTrackerImageView, titleOfTrackerLabel, countDaysLabel, completeButton]
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        contentView.addSubviews(views)
        setupView()
        setupQuantityManagment()
    }
    
    private func setupView() {
        titleOfTrackerLabel.numberOfLines = 2
        titleOfTrackerLabel.font = UIFont.systemFont(ofSize: TextSize.ofLabels, weight: .medium)
        titleOfTrackerLabel.textColor = .white
        pinTrackerImageView.tintColor = .white
        pinTrackerImageView.contentMode = .center
        emojiLabel.font = UIFont.systemFont(ofSize: TextSize.ofLabels, weight: .medium)
        emojiLabel.textAlignment = .center
        emojiLabel.backgroundColor = Color.ofBackgroundColorForEmoji
        emojiLabel.layer.masksToBounds = true
        emojiLabel.layer.cornerRadius = CornerRadius.ofEmojiLabel
        cardTracker.layer.cornerRadius = CornerRadius.ofCard
        NSLayoutConstraint.activate([
            cardTracker.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardTracker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardTracker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardTracker.heightAnchor.constraint(equalToConstant: Height.ofCard),
            emojiLabel.topAnchor.constraint(equalTo: cardTracker.topAnchor, constant: 12.0),
            emojiLabel.leadingAnchor.constraint(equalTo: cardTracker.leadingAnchor, constant: 12.0),
            emojiLabel.heightAnchor.constraint(equalToConstant: Size.ofEmojiAndPin),
            emojiLabel.widthAnchor.constraint(equalToConstant: Size.ofEmojiAndPin),
            pinTrackerImageView.topAnchor.constraint(equalTo: emojiLabel.topAnchor),
            pinTrackerImageView.trailingAnchor.constraint(equalTo: cardTracker.trailingAnchor, constant: -4.0),
            pinTrackerImageView.heightAnchor.constraint(equalToConstant: Size.ofEmojiAndPin),
            pinTrackerImageView.widthAnchor.constraint(equalToConstant: Size.ofEmojiAndPin),
            titleOfTrackerLabel.bottomAnchor.constraint(equalTo: cardTracker.bottomAnchor, constant: -12.0),
            titleOfTrackerLabel.leadingAnchor.constraint(equalTo: cardTracker.leadingAnchor, constant: 12.0),
            titleOfTrackerLabel.trailingAnchor.constraint(equalTo: cardTracker.trailingAnchor, constant: -12.0),
            titleOfTrackerLabel.heightAnchor.constraint(equalToConstant: Height.ofTitleLabel)
        ])
    }
    
    private func setupQuantityManagment() {
        completeButton.addAction(
            UIAction(handler: { [weak self] _ in
                guard let self = self,
                      let currentImage = self.completeButton.currentImage
                else {
                    return
                }
                // TODO: - Will be done later
                if currentImage == Image.ofButtonWithPlus {
                    self.updateCountDaysLabel(1)
                    self.completeButton.setImage(Image.ofButtonWithCheckmark, for: .normal)
                } else {
                    self.updateCountDaysLabel(-1)
                    self.completeButton.setImage(Image.ofButtonWithPlus, for: .normal)
                }
            }),
            for: .touchUpInside)
        completeButton.setImage(Image.ofButtonWithPlus, for: .normal)
        countDaysLabel.textColor = .ypBlack
        countDaysLabel.font = UIFont.systemFont(ofSize: TextSize.ofLabels, weight: .medium)
        countDaysLabel.text = "0 дней"
        NSLayoutConstraint.activate([
            completeButton.topAnchor.constraint(equalTo: cardTracker.bottomAnchor, constant: 8.0),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12.0),
            completeButton.heightAnchor.constraint(equalToConstant: Size.ofButton),
            completeButton.widthAnchor.constraint(equalToConstant: Size.ofButton),
            countDaysLabel.centerYAnchor.constraint(equalTo: completeButton.centerYAnchor),
            countDaysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12.0),
            countDaysLabel.trailingAnchor.constraint(equalTo: completeButton.leadingAnchor, constant: -8.0),
            countDaysLabel.heightAnchor.constraint(equalToConstant: Height.ofCountDaysLabel),
        ])
    }
    
    private func updateCountDaysLabel(_ value: Int) {
        guard let text = countDaysLabel.text,
              var days = Int(text.split(separator: " ")[0]) else {
            return
        }
        days += value
        if days % 10 == 1 && days % 100 != 11 {
            countDaysLabel.text = "\(days) день"
        } else if Set(2...4).contains(days %  10) && !Set(2...4).contains(days %  100)  {
            countDaysLabel.text = "\(days) дня"
        } else {
            countDaysLabel.text = "\(days) дней"
        }
    }
}
