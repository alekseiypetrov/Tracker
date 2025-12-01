import UIKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        enum Sizes {
            static let spacingBetweenCells: CGFloat = 12.0
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
        static let titles = [
            NSLocalizedString("completedTrackersTitle", comment: ""),
            NSLocalizedString("averageRatePerDaysTitle", comment: ""),
            NSLocalizedString("maximumTrackersPerDayTitle", comment: ""),
        ]
        static let keys = ["completedTrackers", "averageRate", "maximumTrackers"]
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
        tableView.backgroundColor = .ypWhite
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StatisticsTableViewCell.self, forCellReuseIdentifier: StatisticsTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - Private properties
    
    private var statisticsData: [Int] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsAndConstaints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statisticsData = Constants.keys.map {
            UserDefaults.standard.integer(forKey: $0)
        }
        nothingToAnalyze() ? hideTable() : showTable()
    }
    
    // MARK: - Private methods
    
    private func nothingToAnalyze() -> Bool {
        statisticsData.allSatisfy { $0 == 0 }
    }
    
    private func hideTable() {
        [imageView, emptyStatisticsListLabel].forEach { $0.isHidden = false }
        tableView.isHidden = true
    }
    
    private func showTable() {
        [imageView, emptyStatisticsListLabel].forEach { $0.isHidden = true }
        tableView.isHidden = false
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setupViewsAndConstaints() {
        let views: [UIView] = [titleStatisticsLabel, imageView, emptyStatisticsListLabel, tableView]
        view.addSubviews(views)
        
        NSLayoutConstraint.activate([
            
            // titleStatisticsLabel
            titleStatisticsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            titleStatisticsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            titleStatisticsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44.0),
            titleStatisticsLabel.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfTitleStatisticsLabel),
            
            // tableView
            tableView.topAnchor.constraint(equalTo: titleStatisticsLabel.bottomAnchor, constant: 77.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // imageView
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Constants.Sizes.sizeOfImageOfEmptyList),
            imageView.heightAnchor.constraint(equalToConstant: Constants.Sizes.sizeOfImageOfEmptyList),
            
            // emptyStatisticsListLabel
            emptyStatisticsListLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            emptyStatisticsListLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            emptyStatisticsListLabel.topAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.bottomAnchor, constant: 8.0),
            emptyStatisticsListLabel.heightAnchor.constraint(equalToConstant: Constants.Sizes.heightOfEmptyListLabel),
        ])
    }
}

// MARK: - StatisticsViewController + UITableViewDataSource

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Constants.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentCell = tableView.dequeueReusableCell(withIdentifier: StatisticsTableViewCell.identifier) as? StatisticsTableViewCell
        else { return UITableViewCell() }
        currentCell.configCell(withTitle: Constants.titles[indexPath.row],
                               andNumber: statisticsData[indexPath.row])
        return currentCell
    }
}

// MARK: - StatisticsViewController + UITableViewDelegate

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.Sizes.heightOfCellInList + Constants.Sizes.spacingBetweenCells
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layoutMargins = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: Constants.Sizes.spacingBetweenCells,
            right: 0
        )
    }
}
