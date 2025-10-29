protocol TimetableTableViewCellDelegate: AnyObject {
    func add(day fullNameOfDay: String)
    func remove(day fullNameOfDay: String)
}
