import UIKit

final class OnboardingPageViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let heightOfLabel: CGFloat = 96.0
        static let fontForLabel = UIFont.systemFont(ofSize: 32.0, weight: .bold)
    }
    
    // MARK: - UI-elements
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .ypBlack
        label.font = Constants.fontForLabel
        label.textAlignment = .center
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        UIImageView()
    }()
    
    // MARK: - Initializers
    
    init(pageModel: PageModel) {
        super.init(nibName: nil, bundle: nil)
        label.text = pageModel.title
        imageView.image = pageModel.image
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        view.addSubviews([imageView, label])
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor),
            label.heightAnchor.constraint(equalToConstant: Constants.heightOfLabel),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 64.0)
        ])
    }
}
