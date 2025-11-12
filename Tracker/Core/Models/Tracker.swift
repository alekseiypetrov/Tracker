import UIKit

struct Tracker {
    let id: UInt
    let name: String
    let color: UIColor
    let emoji: String
    let timetable: [Weekday]
    
    static func convert(from trackerCoreData: TrackerCoreData) -> Tracker? {
        guard let name = trackerCoreData.name,
              let emoji = trackerCoreData.emoji,
              let color = trackerCoreData.color as? UIColor,
              let timetable = trackerCoreData.timetable as? [Weekday]
        else { return nil }
        return Tracker(id: UInt(trackerCoreData.id),
                       name: name,
                       color: color,
                       emoji: emoji,
                       timetable: timetable)
    }
}
