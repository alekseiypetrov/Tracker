import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let imageAddTrackerButton = UIImage(named: "add_tracker_image")
        static let imageOfEmptyList = UIImage(named: "empty_list_image")
        static let imageOfButtonWithPlus = UIImage(systemName: "plus.circle.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: Constants.sizeOfButtonInCell))
        static let imageOfButtonWithCheckmark = UIImage(systemName: "checkmark.circle.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: Constants.sizeOfButtonInCell))
        static let sizeOfButtonInCell: CGFloat = 24.0
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
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.addTracker()
        }),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        var calendar = Calendar(identifier: .iso8601)
        calendar.firstWeekday = 2
        datePicker.calendar = calendar
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
                            Tracker(id: 2, name: "Помыть полы", color: .ypBlue, emoji: "😇", timetable: [.tuesday, .friday]),
                        ]),
        TrackerCategory(title: "Проект разгром",
                        trackers: [
                            Tracker(id: 3, name: "Сварить мыло", color: .ypGray, emoji: "🧼", timetable: [.thursday]),
                            Tracker(id: 4, name: "Уничтожить предмет искусства", color: .orange, emoji: "🧨", timetable: [.saturday, .tuesday]),
                            Tracker(id: 5, name: "Подраться с незнакомцем", color: .cyan, emoji: "👊🏻", timetable: [.friday, .sunday]),
                        ])
    ]
    private var filteredCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviewsAndConstraints()
    }
    
    // MARK: - Private Methods
    
    @objc
    private func addTracker() {
        let createTrackerViewController = CreateHabbitViewController() // CreateTrackerViewController()
        createTrackerViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: createTrackerViewController)
        present(navigationController, animated: true)
    }
    
    @objc 
    private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
        let calendar = sender.calendar
        print(calendar?.component(.weekday, from: selectedDate))
        collectionView.reloadData()
    }
    
    private func hideCollection() {
        [imageViewOfEmptyList, titleOfEmptyListLabel].forEach { $0.isHidden = false }
        collectionView.isHidden = true
    }
    
    private func showCollection() {
        [imageViewOfEmptyList, titleOfEmptyListLabel].forEach { $0.isHidden = true }
        collectionView.isHidden = false
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

extension TrackersViewController: TrackersViewControllerDelegate {
    func addNewTracker(_ tracker: Tracker, ofCategory categoryTitle: String) {
        let index: Int = categories.firstIndex(where: { $0.title == categoryTitle }) ?? categories.count
        if index < categories.count {
            let category = categories[index]
            categories[index] = TrackerCategory(title: categoryTitle,
                                                trackers: category.trackers + [tracker])
        } else {
            categories.append(TrackerCategory(title: categoryTitle,
                                              trackers: [tracker]))
        }
        collectionView.reloadData()
    }
}

// MARK: - TrackersViewController + TrackersCollectionViewCellDelegate

extension TrackersViewController: TrackersCollectionViewCellDelegate {
    private func setDaysAtTracker(with id: UInt) -> String {
        let numberOfDays = numberOfTimesCompleted(byTrackerWith: id)
        var resultString: String
        if numberOfDays % 10 == 1 && numberOfDays % 100 != 11 {
            resultString = "\(numberOfDays) день"
        } else if Set(2...4).contains(numberOfDays %  10) && !Set(12...14).contains(numberOfDays %  100)  {
            resultString = "\(numberOfDays) дня"
        } else {
            resultString = "\(numberOfDays) дней"
        }
        return resultString
    }
    
    private func numberOfTimesCompleted(byTrackerWith id: UInt) -> Int {
        completedTrackers.filter { $0.id == id }.count
    }
    
    private func setButtonImageAtTracker(with id: UInt) -> UIImage? {
        let currentDateAtDatePicker = datePicker.date
        let formattedCurrentDate = dateFormatter.string(from: currentDateAtDatePicker)
        return isTrackerDone(atThisDate: formattedCurrentDate, with: id) ? Constants.imageOfButtonWithCheckmark : Constants.imageOfButtonWithPlus
    }
    
    private func isTrackerDone(atThisDate date: String, with id: UInt) -> Bool {
        return !completedTrackers
            .filter { $0.id == id && $0.date == date }
            .isEmpty
    }
    
    func didTappedButtonInTracker(_ tracker: TrackersCollectionViewCell) {
        let currentDateAtDatePicker = datePicker.date
        let isItAFuture = currentDateAtDatePicker.timeIntervalSinceNow > 0
        if isItAFuture {
            return
        }
        guard let indexPath = collectionView.indexPath(for: tracker) else {
            return
        }
        let formattedCurrentDate = dateFormatter.string(from: currentDateAtDatePicker)
        let idOfTracker = filteredCategories[indexPath.section].trackers[indexPath.row].id
        if !isTrackerDone(atThisDate: formattedCurrentDate, with: idOfTracker) {
            let newRecord = TrackerRecord(id: idOfTracker,
                                          date: formattedCurrentDate)
            completedTrackers.append(newRecord)
        } else if let indexOfTracker = completedTrackers.firstIndex(where: { $0.id == idOfTracker && $0.date == formattedCurrentDate } ) {
            completedTrackers.remove(at: indexOfTracker)
        }
        tracker.countDaysLabel.text = setDaysAtTracker(with: idOfTracker)
        tracker.completeButton.setImage(setButtonImageAtTracker(with: idOfTracker), for: .normal)
    }
}

// MARK: - TrackersViewController + UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    private func config(_ cell: TrackersCollectionViewCell, at indexPath: IndexPath) {
        cell.delegate = self
        let category = filteredCategories[indexPath.section]
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
        
        cell.countDaysLabel.text = setDaysAtTracker(with: currentTracker.id)
        cell.completeButton.setImage(setButtonImageAtTracker(with: currentTracker.id),
                                     for: .normal)
    }
    
    private func config(_ header: HeaderSupplementaryView, at indexPath: IndexPath) {
        let category = filteredCategories[indexPath.section]
        header.titleLabel.text = category.title
    }
    
    private func filterCategories() {
        let currentDateAtDatePicker = datePicker.date
        guard let calendar = datePicker.calendar,
              let weekday = Weekday(rawValue: calendar.component(.weekday, from: currentDateAtDatePicker)) else {
            return
        }
        filteredCategories = categories
            .filter {
                !$0.trackers.filter {
                    $0.timetable.contains(weekday)
                }.isEmpty
            }.map {
                TrackerCategory(title: $0.title,
                                trackers: $0.trackers.filter {
                    $0.timetable.contains(weekday)
                })
            }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        filterCategories()
        if filteredCategories.isEmpty {
            hideCollection()
            return 0
        }
        showCollection()
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let category = filteredCategories[section]
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

// MARK: - TrackersViewController + UICollectionViewDelegateFlowLayout & UICollectionViewDelegate

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
