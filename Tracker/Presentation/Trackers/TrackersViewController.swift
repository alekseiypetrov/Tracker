import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let imageAddTrackerButton = UIImage(named: "add_tracker_image")
        static let imageOfEmptyList = UIImage(named: "empty_list_image")
        static let addTrackerButtonSize: CGFloat = 42.0
        static let titleTrackerSizeOfText: CGFloat = 34.0
        static let titleTrackerLabelSize: CGSize = CGSize(width: 254.0, height: 41.0)
        static let imageViewOfEmptyListSize: CGFloat = 80.0
        static let titleOfEmptyListSizeOfText: CGFloat = 12.0
        static let titleOfEmptyListLabelHeight: CGFloat = 18.0
        static let datePickerSize: CGSize = CGSize(width: 97.0, height: 34.0)
        static let searchBarHeight: CGFloat = 36.0
        static let heightOfCell: CGFloat = 148.0
        static let edgeInsetsForSection: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
        static let verticalSpacing: CGFloat = 0.0
        static let horizontalSpacing: CGFloat = 9.0
    }
    
    // MARK: - UI-elements
    
    private lazy var addTrackerButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.imageAddTrackerButton, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    private lazy var titleTrackerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.titleTrackerSizeOfText)
        label.text = "Трекеры"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: TrackersCollectionViewCell.identifier)
        collectionView.register(HeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSupplementaryView.identifier)
        return collectionView
    }()
    
    private lazy var imageViewOfEmptyList: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.imageOfEmptyList
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleOfEmptyListLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.titleOfEmptyListSizeOfText)
        label.text = "Что будем отслеживать?"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Private Properties
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter
    }()
    
    private var categories: [TrackerCategory] = [
        TrackerCategory(title: "Домашний уют",
                        trackers: [
                            Tracker(id: 1, name: "Поливать растения", color: .ypRed, emoji: "❤️", timetable: [.monday]),
                            Tracker(id: 2, name: "Помыть полы", color: .ypBlue, emoji: "😇", timetable: [.wednesday, .sunday]),
                        ]),
        TrackerCategory(title: "Проект разгром",
                        trackers: [
                            Tracker(id: 3, name: "Сварить мыло", color: .ypGrey, emoji: "🧼", timetable: [.monday]),
                            Tracker(id: 4, name: "Уничтожить предмет искусства", color: .orange, emoji: "🧨", timetable: [.wednesday, .sunday]),
                            Tracker(id: 5, name: "Подраться с незнакомцем", color: .cyan, emoji: "👊🏻", timetable: [.wednesday, .sunday]),
                        ])
    ]
    private var completedTrackers: [TrackerRecord] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviewsAndConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if categories.isEmpty {
            [imageViewOfEmptyList, titleOfEmptyListLabel].forEach { $0.isHidden = false }
            collectionView.isHidden = true
        } else {
            [imageViewOfEmptyList, titleOfEmptyListLabel].forEach { $0.isHidden = true }
            collectionView.isHidden = false
        }
    }
    
    // MARK: - Private Methods
    
    @objc 
    private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
    }
    
    private func setupSubviewsAndConstraints() {
        view.addSubviews([addTrackerButton, datePicker, titleTrackerLabel, searchBar, collectionView, imageViewOfEmptyList, titleOfEmptyListLabel])
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        NSLayoutConstraint.activate([
            addTrackerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6.0),
            addTrackerButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1.0),
            addTrackerButton.widthAnchor.constraint(equalToConstant: Constants.addTrackerButtonSize),
            addTrackerButton.heightAnchor.constraint(equalToConstant: Constants.addTrackerButtonSize),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            datePicker.centerYAnchor.constraint(equalTo: addTrackerButton.centerYAnchor),
            datePicker.widthAnchor.constraint(equalToConstant: Constants.datePickerSize.width),
            datePicker.heightAnchor.constraint(equalToConstant: Constants.datePickerSize.height),
            titleTrackerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            titleTrackerLabel.topAnchor.constraint(equalTo: addTrackerButton.bottomAnchor, constant: 1.0),
            titleTrackerLabel.widthAnchor.constraint(equalToConstant: Constants.titleTrackerLabelSize.width),
            titleTrackerLabel.heightAnchor.constraint(equalToConstant: Constants.titleTrackerLabelSize.height),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            searchBar.topAnchor.constraint(equalTo: titleTrackerLabel.bottomAnchor, constant: 7.0),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            searchBar.heightAnchor.constraint(equalToConstant: Constants.searchBarHeight),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8.0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageViewOfEmptyList.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageViewOfEmptyList.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageViewOfEmptyList.widthAnchor.constraint(equalToConstant: Constants.imageViewOfEmptyListSize),
            imageViewOfEmptyList.heightAnchor.constraint(equalToConstant: Constants.imageViewOfEmptyListSize),
            titleOfEmptyListLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            titleOfEmptyListLabel.topAnchor.constraint(equalTo: imageViewOfEmptyList.bottomAnchor, constant: 8.0),
            titleOfEmptyListLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
        ])
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    private func config(_ cell: TrackersCollectionViewCell, at indexPath: IndexPath) {
        let category = categories[indexPath.section]
        let currentTracker = category.trackers[indexPath.row]
        cell.cardTracker.backgroundColor = currentTracker.color
        cell.completeButton.tintColor = currentTracker.color
        cell.emojiLabel.text = currentTracker.emoji
        cell.pinTrackerImageView.isHidden = category.title == "Закрепленные" ? false : true
        
        cell.titleOfTrackerLabel.text = currentTracker.name
        let constraintRect = CGSize(width: cell.frame.size.width - 24.0,
                                    height: CGFloat.greatestFiniteMagnitude)
        let sizeOfTitleText = currentTracker.name.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: cell.titleOfTrackerLabel.font],
            context: nil
        )
        let numberOfLines = Int(ceil(sizeOfTitleText.height / cell.titleOfTrackerLabel.font.lineHeight))
        if numberOfLines == 1 {
            cell.titleOfTrackerLabel.text = "\n\(currentTracker.name)"
        }
        
        // TODO: - Will be done later (настройка кнопки и лейбла)
    }
    
    private func config(_ header: HeaderSupplementaryView, at indexPath: IndexPath) {
        let category = categories[indexPath.section]
        header.titleLabel.text = category.title
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let category = categories[section]
        return category.trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let currentCell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: TrackersCollectionViewCell.identifier,
                for: indexPath) as? TrackersCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        config(currentCell, at: indexPath)
        return currentCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = HeaderSupplementaryView.identifier
        default:
            id = ""
        }
        
        guard let currentSupplementaryView = collectionView
            .dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? HeaderSupplementaryView else {
            return UICollectionReusableView()
        }
        config(currentSupplementaryView, at: indexPath)
        return currentSupplementaryView
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - Constants.horizontalSpacing - 2 * Constants.edgeInsetsForSection.left) / 2
        return CGSize(width: cellWidth, height: Constants.heightOfCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.edgeInsetsForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.horizontalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.verticalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width,
                   height: 20.0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
    }
}
