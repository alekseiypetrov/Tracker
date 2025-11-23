import UIKit

struct PageModel {
    let title: String
    let image: UIImage
}

extension PageModel {
    static let aboutTracking = PageModel(title: NSLocalizedString("aboutTrackingTitle", comment: ""), image: UIImage.bluePage)
    static let aboutWaterAndYoga = PageModel(title: NSLocalizedString("aboutWaterAndYogaTitle", comment: ""), image: UIImage.redPage)
}

final class OnboardingViewController: UIPageViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 16.0
        static let heightOfPageControl: CGFloat = 6.0
        static let heightOfButton: CGFloat = 60.0
        static let titleForButton = NSAttributedString(
            string: NSLocalizedString("onboardingButtonTitle", comment: ""),
            attributes: [.font: UIFont.systemFont(ofSize: 16.0, weight: .medium),
                         .foregroundColor: UIColor.ypWhite])
    }
    
    // MARK: - Private properties
    
    var sceneDelegate: SceneDelegateProtocol?
    private lazy var pages: [UIViewController] = {
        [
            OnboardingPageViewController(pageModel: PageModel.aboutTracking),
            OnboardingPageViewController(pageModel: PageModel.aboutWaterAndYoga),
        ]
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
            self?.sceneDelegate?.routeFromOnboardingToMainPage()
        }),
                         for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initializers
    
    init(sceneDelegate: SceneDelegateProtocol) {
        self.sceneDelegate = sceneDelegate
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
    
    // MARK: - Private methods
    
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
