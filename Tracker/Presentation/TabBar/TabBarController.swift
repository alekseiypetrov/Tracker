import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Constants
    
    private enum Constants {
        enum Images {
            static let trackerBarItemImage = UIImage.trackerBarItem.withTintColor(.ypGray)
            static let trackerBarItemImageFilled = UIImage.trackerBarItem.withTintColor(.ypBlue)
            static let statisticsBarItemImage = UIImage.statisticsBarItem.withTintColor(.ypGray)
            static let statisticsBarItemImageFilled = UIImage.statisticsBarItem.withTintColor(.ypBlue)
        }
        static let separatorColor: UIColor = .colorAboveTabbar
    }
    
    // MARK: - Separator
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.separatorColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupViewControllers()
    }
    
    // MARK: - Private methods
    
    private func setupTabBar() {
        view.backgroundColor = .ypWhite
        view.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: tabBar.topAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    private func setupViewControllers() {
        let trackerVC = TrackersViewController()
        trackerVC.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: Constants.Images.trackerBarItemImageFilled,
            selectedImage: Constants.Images.trackerBarItemImage)
        
        let statisticsVC = StatisticsViewController()
        statisticsVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: Constants.Images.statisticsBarItemImageFilled,
            selectedImage: Constants.Images.statisticsBarItemImage)
        
        self.viewControllers = [trackerVC, statisticsVC]
    }
}
