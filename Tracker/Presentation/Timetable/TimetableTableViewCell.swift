import UIKit

final class TimetableTableViewCell: UITableViewCell {
    
    // MARK: - Static properties
    
    static let identifier = "dayOfTheWeekCellIdentifier"
    
    // MARK: - Constants
    
    private enum Constants {
        enum Sizes {
            static let sizeOfText: CGFloat = 17.0
            static let heightOfLabel: CGFloat = 22.0
            static let sizeOfSwitchBar: CGSize = CGSize(width: 51.0, height: 31.0)
        }
        static let fontForLabel = UIFont.systemFont(ofSize: Sizes.sizeOfText, weight: .regular)
    }
    
    // MARK: - UI-elements
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = Constants.fontForLabel
        return label
    }()
    
    lazy var switchBar: UISwitch = {
        let switchBar = UISwitch()
        switchBar.tintColor = .ypLightGray
        switchBar.onTintColor = .ypBlue
        switchBar.isOn = false
        switchBar.addTarget(self, action: #selector(switchIsToggled), for: .valueChanged)
        return switchBar
    }()
    
    // MARK: - Public properties
    
    weak var delegate: TimetableTableViewCellDelegate?
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Ошибка в init?(coder:)")
    }
    
    // MARK: - Actions
    
    @objc
    private func switchIsToggled() {
        guard let day = dayLabel.text else { return }
        switchBar.isOn ? delegate?.add(day: day) : delegate?.remove(day: day)
    }
    
    // MARK: - Private methods
    
    private func setupViewsAndConstraints() {
        let views = [dayLabel, switchBar]
        contentView.addSubviews(views)
        contentView.backgroundColor = .ypBackground
        
        NSLayoutConstraint.activate([
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            dayLabel.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfLabel),
            switchBar.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor),
            switchBar.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 16.0),
            switchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            switchBar.widthAnchor.constraint(equalToConstant: Constants.Sizes.sizeOfSwitchBar.width),
            switchBar.heightAnchor.constraint(equalToConstant: Constants.Sizes.sizeOfSwitchBar.height),
        ])
    }
}
