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
            static let datePickerSize: CGSize = CGSize(width: 87.0, height: 34.0)
            static let searchBarHeight: CGFloat = 36.0
            static let heightOfCell: CGFloat = 148.0
            static let sizeOfFilterButton = CGSize(width: 114, height: 50)
        }
        enum Spacing {
            static let verticalSpacing: CGFloat = 0.0
            static let horizontalSpacing: CGFloat = 9.0
        }
        static let cornerRadiusOfFilterButton: CGFloat = 16.0
        static let titleForFilterButton = NSAttributedString(
            string: NSLocalizedString("titleOfFilterButton", comment: ""),
            attributes: [.font: UIFont.systemFont(ofSize: 17.0, weight: .regular),
                         .foregroundColor: UIColor.white])
        static let backgroundColorOfDatePicker = UIColor(red: 240.0 / 255.0, green: 240.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
        static let edgeInsetsForSection: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 12.0)
    }
    
    // MARK: - UI-elements
    
    private lazy var addTrackerButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Images.imageAddTrackerButton, for: .normal)
        button.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    AnalyticsService.shared.sendEvent(name: "addTrackerButton_tap",
                                                      parameters: ["event": "click",
                                                                   "screen": "Main",
                                                                   "item": "add_track"])
                    self.addTracker()
                }),
            for: .touchUpInside)
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.overrideUserInterfaceStyle = .light
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        datePicker.calendar = calendar
        if let button = self.findButton(in: datePicker) {
            button.backgroundColor = Constants.backgroundColorOfDatePicker
            button.layer.cornerRadius = 8
            button.layer.masksToBounds = true
        }
        return datePicker
    }()
    
    private lazy var titleTrackerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.Sizes.titleTrackerSizeOfText)
        label.text = NSLocalizedString("trackersViewControllerHeader", comment: "")
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = NSLocalizedString("searchBarPlaceholder", comment: "")
        searchBar.barTintColor = .ypWhite
        searchBar.backgroundColor = .ypWhite
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
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
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlue
        button.setAttributedTitle(Constants.titleForFilterButton, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadiusOfFilterButton
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            AnalyticsService.shared.sendEvent(name: "filterButton_tap",
                                              parameters: ["event": "click",
                                                           "screen": "Main",
                                                           "item": "filter"])
            // TODO: - Will be done later (вызов метода для фильтра трекеров)
            let chooseFilterViewController = ChooseFilterViewController(delegate: self)
            self.present(chooseFilterViewController, animated: true)
        }),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var imageViewOfEmptyList: UIImageView = {
        UIImageView(image: Constants.Images.imageOfEmptyList)
    }()
    
    private lazy var titleOfEmptyListLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.Sizes.titleOfEmptyListSizeOfText)
        label.text = NSLocalizedString("titleOfEmptyListOfTrackers", comment: "")
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Private properties
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter
    }()
    
    private var currentTextInSearchBar: String?
    private var filteredCategories: [TrackerCategory] = []
    private var categoriesOnAGivenDay: [TrackerCategory] = []
    private var categoryStore: TrackerCategoryStore?
    private var recordStore: TrackerRecordStore?
    private var trackerStore: TrackerStore?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryStore = TrackerCategoryStore()
        categoryStore?.delegate = self
        trackerStore = TrackerStore(delegate: self)
        recordStore = TrackerRecordStore()
        setupSubviewsAndConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AnalyticsService.shared.sendEvent(name: "TrackersViewController_opening",
                                          parameters: ["event": "open",
                                                       "screen": "Main"])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AnalyticsService.shared.sendEvent(name: "TrackersViewController_closing",
                                          parameters: ["event": "close",
                                                       "screen": "Main"])
    }
    
    // MARK: - Actions
    
    private func addTracker() {
        let createTrackerViewController = ChooseKindOfNewTrackerViewController()
        createTrackerViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: createTrackerViewController)
        present(navigationController, animated: true)
    }
    
    @objc 
    private func datePickerValueChanged(_ sender: UIDatePicker) {
        collectionView.reloadData()
    }
    
    // MARK: - Private methods
    
    private func findButton(in view: UIView) -> UIButton? {
        for subview in view.subviews {
            if let button = subview as? UIButton {
                return button
            }
            if let found = findButton(in: subview) {
                return found
            }
        }
        return nil
    }

    private func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: NSLocalizedString("alertHeader", comment: ""),
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("alertTitleOfButton", comment: ""), style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func hideCollection() {
        [imageViewOfEmptyList, titleOfEmptyListLabel].forEach { $0.isHidden = false }
        [collectionView, filterButton].forEach { $0.isHidden = true }
    }
    
    private func showCollection() {
        [imageViewOfEmptyList, titleOfEmptyListLabel].forEach { $0.isHidden = true }
        [collectionView, filterButton].forEach { $0.isHidden = false }
    }
    
    private func setupSubviewsAndConstraints() {
        view.addSubviews([addTrackerButton, datePicker, titleTrackerLabel, searchBar, collectionView, filterButton, imageViewOfEmptyList, titleOfEmptyListLabel])
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
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0),
            filterButton.widthAnchor.constraint(equalToConstant: Constants.Sizes.sizeOfFilterButton.width),
            filterButton.heightAnchor.constraint(equalToConstant: Constants.Sizes.sizeOfFilterButton.height),
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

// MARK: - TrackersViewController + TrackerCategoryStoreDelegate

extension TrackersViewController: TrackerCategoryStoreDelegate {
    func didUpdated(_ updates: CategoryUpdateValues) { return }
}

// MARK: - TrackersViewController + TrackerStoreDelegate

extension TrackersViewController: TrackerStoreDelegate {
    func didUpdated() {
        collectionView.reloadData()
    }
}

// MARK: - TrackersViewController + TrackersViewControllerDelegate

extension TrackersViewController: TrackersViewControllerDelegate {
    func updateCollection(by filter: String) {
        // TODO: - Will be done later (доп фильрация)
    }
    
    private func deleteTracker(_ tracker: Tracker) {
        do {
            try trackerStore?.deleteTracker(fromObject: tracker)
        } catch CoreDataError.nonExistentValue(let message) {
            showAlert(withMessage: message)
        } catch {
            showAlert(withMessage: NSLocalizedString("undefinedError", comment: ""))
        }
    }
    
    func updateTracker(_ tracker: Tracker, ofCategory categoryTitle: String) {
        do {
            guard let categoryStore else { throw CoreDataError.invalidStore }
            try trackerStore?.updateTracker(fromObject: tracker, toCategory: categoryTitle, categoryStore: categoryStore)
            dismiss(animated: true)
        } catch CoreDataError.nonExistentValue(let message) {
            dismiss(animated: true) { [weak self] in
                self?.showAlert(withMessage: message)
            }
        } catch {
            dismiss(animated: true) { [weak self] in
                self?.showAlert(withMessage: NSLocalizedString("undefinedError", comment: ""))
            }
        }
    }
    
    func addNewTracker(name: String, 
                       color: UIColor,
                       emoji: String,
                       timetable: [Weekday],
                       ofCategory categoryTitle: String) {
        do {
            guard let numberOfTrackers = trackerStore?.getNumberOfAllTrackers(),
                  let categoryStore
            else { throw CoreDataError.nonExistentValue(NSLocalizedString("nonExistentValue", comment: "")) }
            let tracker = Tracker(id: UInt(numberOfTrackers + 1),
                                  name: name,
                                  color: color,
                                  emoji: emoji,
                                  timetable: timetable)
            try trackerStore?.addTracker(fromObject: tracker, toCategory: categoryTitle, categoryStore: categoryStore)
            dismiss(animated: true)
        } catch CoreDataError.duplicatingValue(let message) {
            dismiss(animated: true) { [weak self] in
                self?.showAlert(withMessage: message)
            }
        } catch CoreDataError.nonExistentValue(let message) {
            dismiss(animated: true) { [weak self] in
                self?.showAlert(withMessage: message)
            }
        } catch {
            dismiss(animated: true) { [weak self] in
                self?.showAlert(withMessage: NSLocalizedString("undefinedError", comment: ""))
            }
        }
    }
    
    func showViewController(whichName name: ViewController) {
        var navigationController: UINavigationController, flag: Bool
        switch name {
        case .habit:
            flag = true
        case .event:
            flag = false
        }
        let viewController = CreateTrackerViewController(kindOfTrackerIsAHabit: flag)
        viewController.delegate = self
        navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
}

// MARK: - TrackersViewController + UISearchBarDelegate

extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentTextInSearchBar = searchText
        collectionView.reloadData()
    }
}

// MARK: - TrackersViewController + TrackersCollectionViewCell

extension TrackersViewController: TrackersCollectionViewCellDelegate {
    private func setDaysAtTracker(with id: UInt) -> String {
        String.localizedStringWithFormat(
            NSLocalizedString("numberOfDays", comment: "A number of days which a tracker was completed"),
            numberOfTimesCompleted(byTrackerWith: id))
    }
    
    private func numberOfTimesCompleted(byTrackerWith id: UInt) -> Int {
        recordStore?.getNumberOfRecords(ofTrackerWithId: id) ?? 0
    }

    private func setButtonImageAtTracker(with id: UInt) -> UIImage? {
        let currentDateAtDatePicker = datePicker.date
        let formattedCurrentDate = dateFormatter.string(from: currentDateAtDatePicker)
        var image: UIImage?
        if let flag = recordStore?.getStatusOfTracker(withId: id, atDate: formattedCurrentDate),
           flag {
            image = Constants.Images.imageOfButtonWithCheckmark
        } else {
            image = Constants.Images.imageOfButtonWithPlus
        }
        return image
    }
    
    func didTappedButtonInTracker(_ tracker: TrackersCollectionViewCell) {
        AnalyticsService.shared.sendEvent(name: "trackerButton_tap",
                                          parameters: ["event": "click",
                                                       "screen": "Main",
                                                       "item": "track"])
        let currentDateAtDatePicker = datePicker.date
        let isItAFuture = currentDateAtDatePicker.timeIntervalSinceNow > 0
        guard !isItAFuture,
              let indexPath = collectionView.indexPath(for: tracker),
              let trackerStore
        else { return }
        let formattedCurrentDate = dateFormatter.string(from: currentDateAtDatePicker)
        let idOfTracker = filteredCategories[indexPath.section].trackers[indexPath.row].id
        if let flag = recordStore?.getStatusOfTracker(withId: idOfTracker, atDate: formattedCurrentDate),
           flag {
            do {
                try recordStore?.deleteRecord(fromObjectWithId: idOfTracker, atDate: formattedCurrentDate)
                tracker.imageForButton = Constants.Images.imageOfButtonWithPlus
            } catch CoreDataError.nonExistentValue(let message) {
                showAlert(withMessage: message)
            } catch {
                showAlert(withMessage: NSLocalizedString("undefinedError", comment: ""))
            }
        } else {
            recordStore?.addRecord(fromObjectWithId: idOfTracker, atDate: formattedCurrentDate, trackerStore: trackerStore)
            tracker.imageForButton = Constants.Images.imageOfButtonWithCheckmark
        }
        tracker.countDays = setDaysAtTracker(with: idOfTracker)
    }
}

// MARK: - TrackersViewController + UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    private func filterCategories() {
        let currentDateAtDatePicker = datePicker.date
        guard let calendar = datePicker.calendar,
              let weekday = Weekday(rawValue: calendar.component(.weekday, from: currentDateAtDatePicker)),
              let categories = categoryStore?.getCategories()
        else { return }
        categoriesOnAGivenDay = categories
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
        if let currentTextInSearchBar, !currentTextInSearchBar.isEmpty {
            filteredCategories = categoriesOnAGivenDay
                .filter {
                    !$0.trackers.filter {
                        $0.name.lowercased().contains(currentTextInSearchBar.lowercased())
                    }.isEmpty
                }.map {
                    TrackerCategory(title: $0.title,
                                    trackers: $0.trackers.filter {
                        $0.name.lowercased().contains(currentTextInSearchBar.lowercased())
                    })
                }
        } else {
            filteredCategories = categoriesOnAGivenDay
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
                               isPinned: category.title != NSLocalizedString("pinCategory", comment: ""))
        currentCell.countDays = setDaysAtTracker(with: currentTracker.id)
        currentCell.imageForButton = setButtonImageAtTracker(with: currentTracker.id)
        currentCell.delegate = self
        return currentCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String?
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = HeaderSupplementaryView.identifier
        default:
            id = nil
        }
        
        guard let id = id else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: id,
                for: indexPath
            )
            
        guard let headerSupplementaryView = header as? HeaderSupplementaryView else {
            return header
        }
        let categoryTitle = filteredCategories[indexPath.section].title
        headerSupplementaryView.configHeader(withTitle: categoryTitle)
        return headerSupplementaryView
    }
}

// MARK: - TrackersViewController + UICollectionViewDelegateFlowLayout & UICollectionViewDelegate

extension TrackersViewController: UICollectionViewDelegateFlowLayout & UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.row]
        let category = filteredCategories[indexPath.section].title
        let numberOfDays = setDaysAtTracker(with: tracker.id)
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: NSLocalizedString("titleOfEditingInContextMenu", comment: ""),
                         handler: { [weak self] _ in
                             AnalyticsService.shared.sendEvent(name: "editButtonOfContextMenu_tap",
                                                               parameters: ["event": "click",
                                                                            "screen": "Main",
                                                                            "item": "edit"])
                             let viewController = EditTrackerViewController(
                                tracker: tracker,
                                withNumberOfCompletedDays: numberOfDays,
                                atCategory: category)
                             viewController.delegate = self
                             self?.present(viewController, animated: true)
                         }),
                UIAction(title: NSLocalizedString("titleOfDeletingInContextMenu", comment: ""),
                         attributes: .destructive,
                         handler: { [weak self] _ in
                             AnalyticsService.shared.sendEvent(name: "deleteButtonOfContextMenu_tap",
                                                               parameters: ["event": "click",
                                                                            "screen": "Main",
                                                                            "item": "delete"])
                             let alert = UIAlertController(
                                title: NSLocalizedString("alertHeaderForDeleting", comment: ""),
                                message: nil,
                                preferredStyle: .actionSheet)
                             
                             alert.addAction(UIAlertAction(
                                title: NSLocalizedString("alertTitleOfDeleteButton", comment: ""),
                                style: .destructive, handler: { _ in
                                    self?.deleteTracker(tracker)
                                 }))
                             alert.addAction(UIAlertAction(
                                title: NSLocalizedString("alertTitleOfCancelButton", comment: ""),
                                style: .cancel))
                             self?.present(alert, animated: true)
                         }),
            ])
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - Constants.Spacing.horizontalSpacing - 2 * Constants.edgeInsetsForSection.left) / 2
        return CGSize(width: cellWidth, height: Constants.Sizes.heightOfCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == filteredCategories.count - 1 {
            var insets = Constants.edgeInsetsForSection
            insets.bottom += Constants.Sizes.sizeOfFilterButton.height + Constants.Spacing.horizontalSpacing
            return insets
        }
        return Constants.edgeInsetsForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.Spacing.horizontalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.Spacing.verticalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width,
                   height: 46.0)
    }
}
