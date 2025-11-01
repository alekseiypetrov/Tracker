import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        enum Images {
            static let imageAddTrackerButton = UIImage.addTracker
                .withTintColor(.ypBlack, renderingMode: .alwaysOriginal)
            static let imageOfEmptyList = UIImage.emptyList
            static let imageOfButtonWithPlus = UIImage(systemName: "plus.circle.fill")?
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: Sizes.sizeOfButtonInCell))
            static let imageOfButtonWithCheckmark = UIImage(systemName: "checkmark.circle.fill")?
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: Sizes.sizeOfButtonInCell))
        }
        enum Sizes {
            static let sizeOfButtonInCell: CGFloat = 34.0
            static let addTrackerButtonSize: CGFloat = 42.0
            static let titleTrackerSizeOfText: CGFloat = 34.0
            static let titleTrackerLabelSize: CGSize = CGSize(width: 254.0, height: 41.0)
            static let imageViewOfEmptyListSize: CGFloat = 80.0
            static let titleOfEmptyListSizeOfText: CGFloat = 12.0
            static let titleOfEmptyListLabelHeight: CGFloat = 18.0
            static let datePickerSize: CGSize = CGSize(width: 97.0, height: 34.0)
            static let searchBarHeight: CGFloat = 36.0
            static let heightOfCell: CGFloat = 148.0
        }
        enum Spacing {
            static let verticalSpacing: CGFloat = 0.0
            static let horizontalSpacing: CGFloat = 9.0
        }
        static let edgeInsetsForSection: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
    }
    
    // MARK: - UI-elements
    
    private lazy var addTrackerButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Images.imageAddTrackerButton, for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.addTracker()
        }),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        datePicker.calendar = calendar
        return datePicker
    }()
    
    private lazy var titleTrackerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.Sizes.titleTrackerSizeOfText)
        label.text = "Трекеры"
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Поиск"
        searchBar.barTintColor = .ypWhite
        searchBar.backgroundColor = .ypWhite
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .ypWhite
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: TrackersCollectionViewCell.identifier)
        collectionView.register(HeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSupplementaryView.identifier)
        return collectionView
    }()
    
    private lazy var imageViewOfEmptyList: UIImageView = {
        UIImageView(image: Constants.Images.imageOfEmptyList)
    }()
    
    private lazy var titleOfEmptyListLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.Sizes.titleOfEmptyListSizeOfText)
        label.text = "Что будем отслеживать?"
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Private properties
    
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
    
    // MARK: - Actions
    
    private func addTracker() {
        let createTrackerViewController = CreateTrackerViewController()
        createTrackerViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: createTrackerViewController)
        present(navigationController, animated: true)
    }
    
    @objc 
    private func datePickerValueChanged(_ sender: UIDatePicker) {
        collectionView.reloadData()
    }
    
    // MARK: - Private methods
    
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
            addTrackerButton.widthAnchor.constraint(equalToConstant: Constants.Sizes.addTrackerButtonSize),
            addTrackerButton.heightAnchor.constraint(equalToConstant: Constants.Sizes.addTrackerButtonSize),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            datePicker.centerYAnchor.constraint(equalTo: addTrackerButton.centerYAnchor),
            datePicker.widthAnchor.constraint(equalToConstant: Constants.Sizes.datePickerSize.width),
            datePicker.heightAnchor.constraint(equalToConstant: Constants.Sizes.datePickerSize.height),
            titleTrackerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            titleTrackerLabel.topAnchor.constraint(equalTo: addTrackerButton.bottomAnchor, constant: 1.0),
            titleTrackerLabel.widthAnchor.constraint(equalToConstant: Constants.Sizes.titleTrackerLabelSize.width),
            titleTrackerLabel.heightAnchor.constraint(equalToConstant: Constants.Sizes.titleTrackerLabelSize.height),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            searchBar.topAnchor.constraint(equalTo: titleTrackerLabel.bottomAnchor, constant: 7.0),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            searchBar.heightAnchor.constraint(equalToConstant: Constants.Sizes.searchBarHeight),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8.0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageViewOfEmptyList.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageViewOfEmptyList.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageViewOfEmptyList.widthAnchor.constraint(equalToConstant: Constants.Sizes.imageViewOfEmptyListSize),
            imageViewOfEmptyList.heightAnchor.constraint(equalToConstant: Constants.Sizes.imageViewOfEmptyListSize),
            titleOfEmptyListLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            titleOfEmptyListLabel.topAnchor.constraint(equalTo: imageViewOfEmptyList.bottomAnchor, constant: 8.0),
            titleOfEmptyListLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
        ])
    }
}

// MARK: - TrackersViewController + TrackersViewControllerDelegate

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
    
    func showViewController(whichName name: ViewController) {
        var navigationController: UINavigationController
        switch name {
        case .habbit:
            let viewController = CreateHabbitViewController()
            viewController.delegate = self
            navigationController = UINavigationController(rootViewController: viewController)
        case .event:
            let viewController = CreateEventViewController()
            viewController.delegate = self
            navigationController = UINavigationController(rootViewController: viewController)
        }
        present(navigationController, animated: true)
    }
    
    func getNumberOfTrackers() -> UInt {
        UInt(categories.reduce(0, { $0 + $1.trackers.count }))
    }
}

// MARK: - TrackersViewController + TrackersCollectionViewCellDelegate

extension TrackersViewController: TrackersCollectionViewCellDelegate {
    func setDaysAtTracker(with id: UInt) -> String {
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

    func setButtonImageAtTracker(with id: UInt) -> UIImage? {
        let currentDateAtDatePicker = datePicker.date
        let formattedCurrentDate = dateFormatter.string(from: currentDateAtDatePicker)
        return isTrackerDone(atThisDate: formattedCurrentDate, with: id) ? Constants.Images.imageOfButtonWithCheckmark : Constants.Images.imageOfButtonWithPlus
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
        tracker.countDays = setDaysAtTracker(with: idOfTracker)
        tracker.imageForButton = setButtonImageAtTracker(with: idOfTracker)
    }
}

// MARK: - TrackersViewController + UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
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
        let category = filteredCategories[indexPath.section]
        let currentTracker = category.trackers[indexPath.row]
        currentCell.configCell(on: currentTracker, 
                               isPinned: category.title != "Закрепленные")
        currentCell.countDays = setDaysAtTracker(with: currentTracker.id)
        currentCell.imageForButton = setButtonImageAtTracker(with: currentTracker.id)
        currentCell.delegate = self
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
        
        guard let header = collectionView
            .dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? HeaderSupplementaryView else {
            return UICollectionReusableView()
        }
        let categoryTitle = filteredCategories[indexPath.section].title
        header.configHeader(withTitle: categoryTitle)
        return header
    }
}

// MARK: - TrackersViewController + UICollectionViewDelegateFlowLayout & UICollectionViewDelegate

extension TrackersViewController: UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - Constants.Spacing.horizontalSpacing - 2 * Constants.edgeInsetsForSection.left) / 2
        return CGSize(width: cellWidth, height: Constants.Sizes.heightOfCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.edgeInsetsForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.Spacing.horizontalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.Spacing.verticalSpacing
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
