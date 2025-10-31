protocol TrackersViewControllerDelegate: AnyObject {
    func addNewTracker(_ tracker: Tracker, ofCategory categoryTitle: String)
    func showViewController(whichName name: String)
}
