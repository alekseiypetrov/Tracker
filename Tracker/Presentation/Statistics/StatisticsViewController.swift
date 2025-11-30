import UIKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        enum Sizes {
            static let heightOfEmptyListLabel: CGFloat = 18.0
            static let heightOfTitleStatisticsLabel: CGFloat = 41.0
            static let sizeOfImageOfEmptyList: CGFloat = 80.0
            static let heightOfCellInList: CGFloat = 90.0
        }
        enum Fonts {
            static let fontForTitleLabel = UIFont.boldSystemFont(ofSize: 34.0)
            static let fontForEmptyListLabel = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        }
        enum attributedText {
            static let statisticsText = NSAttributedString(
                string: NSLocalizedString("statisticsViewControllerHeader", comment: ""),
                attributes: [.font: Fonts.fontForTitleLabel,
                             .foregroundColor: UIColor.ypBlack])
            static let emptyListText = NSAttributedString(
                string: NSLocalizedString("titleOfEmptyListOfStatistics", comment: ""),
                attributes: [.font: Fonts.fontForEmptyListLabel,
                             .foregroundColor: UIColor.ypBlack])
        }
        static let cellTableViewEdgeInsets = UIEdgeInsets(top: 12.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    // MARK: - UI-elements
    
    private lazy var titleStatisticsLabel: UILabel = {
        let label = UILabel()
        label.attributedText = Constants.attributedText.statisticsText
        label.textAlignment = .left
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        UIImageView(image: UIImage.emptyStatisticsList)
    }()
    
    private lazy var emptyStatisticsListLabel: UILabel = {
        let label = UILabel()
        label.attributedText = Constants.attributedText.emptyListText
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        // TODO: - Configure table
        tableView.rowHeight = Constants.Sizes.heightOfCellInList
        tableView.separatorInset = Constants.cellTableViewEdgeInsets
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsAndConstaints()
    }
    
    // MARK: - Private methods
    
    private func setupViewsAndConstaints() {
        let views: [UIView] = [titleStatisticsLabel, imageView, emptyStatisticsListLabel, tableView]
        view.addSubviews(views)
        
        NSLayoutConstraint.activate([
            titleStatisticsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            titleStatisticsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            titleStatisticsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44.0),
            titleStatisticsLabel.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfTitleStatisticsLabel),
            tableView.topAnchor.constraint(equalTo: titleStatisticsLabel.bottomAnchor, constant: 12.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Constants.Sizes.sizeOfImageOfEmptyList),
            imageView.heightAnchor.constraint(equalToConstant: Constants.Sizes.sizeOfImageOfEmptyList),
            emptyStatisticsListLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            emptyStatisticsListLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            emptyStatisticsListLabel.topAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.bottomAnchor, constant: 8.0),
            emptyStatisticsListLabel.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfEmptyListLabel),
        ])
    }
}

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

extension StatisticsViewController: UITableViewDelegate {
    
}
