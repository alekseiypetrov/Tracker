import UIKit

final class CreateTrackerViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadiusOfButtonAndTable: CGFloat = 16.0
        static let heightOfButton: CGFloat = 60.0
        static let fontForLabels = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        static let attributesForString: [NSAttributedString.Key : Any] = [.font: fontForLabels,
                                                                          .foregroundColor: UIColor.ypWhite]
    }
    
    // MARK: - UI-elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.textAlignment = .center
        label.font = Constants.fontForLabels
        return label
    }()
    
    private lazy var chooseHabbitButton: UIButton = {
        let button = UIButton()
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.createHabbit()
        }),
                         for: .touchUpInside)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = Constants.cornerRadiusOfButtonAndTable
        button.setAttributedTitle(NSAttributedString(string: "Привычка",
                                                     attributes: Constants.attributesForString),
                                  for: .normal)
        return button
    }()
    
    private lazy var chooseEventButton: UIButton = {
        let button = UIButton()
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.createEvent()
        }),
                         for: .touchUpInside)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = Constants.cornerRadiusOfButtonAndTable
        button.setAttributedTitle(NSAttributedString(string: "Нерегулярное событие",
                                                     attributes: Constants.attributesForString),
                                  for: .normal)
        return button
    }()
    
    // MARK: - Public properties
    
    weak var delegate: TrackersViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsAndConstraints()
    }
    
    // MARK: - Actions
    
    private func createHabbit() {
        dismiss(animated: true, completion: { [weak self] in
            guard let self else { return }
            self.delegate?.showViewController(whichName: .habbit)
        })
    }
    
    private func createEvent() {
        dismiss(animated: true, completion: { [weak self] in
            guard let self else { return }
            self.delegate?.showViewController(whichName: .event)
        })
    }
    
    // MARK: - Private methods
    
    private func setupViewsAndConstraints() {
        let views = [titleLabel, chooseHabbitButton, chooseEventButton]
        view.addSubviews(views)
        view.backgroundColor = .ypWhite
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28.0),
            chooseHabbitButton.heightAnchor.constraint(equalToConstant: Constants.heightOfButton),
            chooseHabbitButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            chooseHabbitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            chooseHabbitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            chooseEventButton.heightAnchor.constraint(equalToConstant: Constants.heightOfButton),
            chooseEventButton.topAnchor.constraint(equalTo: chooseHabbitButton.bottomAnchor, constant: 16.0),
            chooseEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            chooseEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
        ])
    }
}
