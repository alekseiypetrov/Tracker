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
        static let datePickerSize: CGSize = CGSize(width: 80.0, height: 34.0)
        static let searchBarHeight: CGFloat = 36.0
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
        datePicker.date = Date.now
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviewsAndConstraints()
    }
    
    // MARK: - Private Methods
    
    private func setupSubviewsAndConstraints() {
        [addTrackerButton, datePicker, titleTrackerLabel,
         searchBar, imageViewOfEmptyList, titleOfEmptyListLabel]
            .forEach({ view.addSubview($0) })
        
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
