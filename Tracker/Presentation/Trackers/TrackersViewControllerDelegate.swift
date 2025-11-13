import UIKit

protocol TrackersViewControllerDelegate: AnyObject {
    func addNewTracker(name: String, color: UIColor, emoji: String, timetable: [Weekday], ofCategory categoryTitle: String)
    func showViewController(whichName name: ViewController)
}
