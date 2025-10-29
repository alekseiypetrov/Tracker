import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let trackerBarItemImage = UIImage(named: "tracker_bar_item")?
            .withTintColor(.ypGrey)
        static let trackerBarItemImageFilled = UIImage(named: "tracker_bar_item")?
            .withTintColor(.ypBlue)
        static let statisticsBarItemImage = UIImage(named: "statistics_bar_item")?
            .withTintColor(.ypGrey)
        static let statisticsBarItemImageFilled = UIImage(named: "statistics_bar_item")?
            .withTintColor(.ypBlue)
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupViewControllers()
    }
    
    // MARK: - Private methods
    
    private func setupViewControllers() {
        let trackerVC = TrackersViewController()
        trackerVC.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: Constants.trackerBarItemImageFilled,
            selectedImage: Constants.trackerBarItemImage)
        
        let statisticsVC = StatisticsViewController()
        statisticsVC.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: Constants.statisticsBarItemImageFilled,
            selectedImage: Constants.statisticsBarItemImage)
        
        self.viewControllers = [trackerVC, statisticsVC]
    }
}
