import UIKit

final class OnboardingViewController: UIPageViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 16.0
        static let heightOfLabel: CGFloat = 96.0
        static let heightOfPageControl: CGFloat = 6.0
        static let heightOfButton: CGFloat = 60.0
        static let titleForButton = NSAttributedString(
            string: "Вот это технологии!", 
            attributes: [.font: UIFont.systemFont(ofSize: 16.0, weight: .medium),
                         .foregroundColor: UIColor.ypWhite])
        static let fontForLabel = UIFont.systemFont(ofSize: 32.0, weight: .bold)
        static let setupForViewControllers: [(String, UIImage)] = [
            ("Отслеживайте только то, что хотите", UIImage.bluePage),
            ("Даже если это не литры воды и йога", UIImage.redPage)
        ]
    }
    
    // MARK: - Private properties
    
    private let userDefaultsKey: String
    private lazy var pages: [UIViewController] = {
        var viewControllers: [UIViewController] = []
        for (title, image) in Constants.setupForViewControllers {
            let viewController = UIViewController()
            let imageView = createImageView(withImage: image)
            let label = createLabel(withTitle: title)
            viewController.view.addSubviews([imageView, label])
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalTo: viewController.view.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: viewController.view.heightAnchor),
                label.heightAnchor.constraint(equalToConstant: Constants.heightOfLabel),
                label.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 16.0),
                label.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -16.0),
                label.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor, constant: 64.0)
            ])
            viewControllers.append(viewController)
        }
        return viewControllers
    }()
    
    // MARK: - UI-elements
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypGray
        return pageControl
    }()
    
    private lazy var acceptButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.setAttributedTitle(Constants.titleForButton, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.acceptButtonPressed()
        }),
                         for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializers
    
    init(_ key: String) {
        userDefaultsKey = key
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        
        if let firstController = pages.first {
            setViewControllers([firstController], direction: .forward, animated: true)
        }
        setupViewAndConstraints()
    }
    
    // MARK: - Actions
    
    private func acceptButtonPressed() {
        UserDefaults.standard.setValue(true, forKey: userDefaultsKey)
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
              let window = sceneDelegate.window
        else {
            assertionFailure("Не удалось получить window из SceneDelegate")
            return
        }
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
    
    // MARK: - Private methods
    
    private func createLabel(withTitle text: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .ypBlack
        label.font = Constants.fontForLabel
        label.textAlignment = .center
        label.text = text
        return label
    }
    
    private func createImageView(withImage image: UIImage) -> UIImageView {
        UIImageView(image: image)
    }
    
    private func setupViewAndConstraints() {
        let views: [UIView] = [pageControl, acceptButton]
        view.addSubviews(views)
        
        NSLayoutConstraint.activate([
            pageControl.heightAnchor.constraint(equalToConstant: Constants.heightOfPageControl),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: acceptButton.topAnchor, constant: -24.0)
        ])
        
        NSLayoutConstraint.activate([
            acceptButton.heightAnchor.constraint(equalToConstant: Constants.heightOfButton),
            acceptButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            acceptButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            acceptButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
        ])
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController)
        else { return nil }
        let previousIndex = currentIndex > 0 ? currentIndex - 1 : pages.count - 1
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController)
        else { return nil }
        let nextIndex = (currentIndex + 1) % pages.count
        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
