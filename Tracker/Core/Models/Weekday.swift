import Foundation

enum Weekday: Int, Codable {
    case monday = 2
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday = 1
    
    var fullName: String {
        switch self {
        case .monday:
            return NSLocalizedString("mondayFull", comment: "")
        case .tuesday:
            return NSLocalizedString("tuesdayFull", comment: "")
        case .wednesday:
            return NSLocalizedString("wednesdayFull", comment: "")
        case .thursday:
            return NSLocalizedString("thursdayFull", comment: "")
        case .friday:
            return NSLocalizedString("fridayFull", comment: "")
        case .saturday:
            return NSLocalizedString("saturdayFull", comment: "")
        case .sunday:
            return NSLocalizedString("sundayFull", comment: "")
        }
    }
    
    var shortName: String {
        switch self {
        case .monday:
            return NSLocalizedString("mondayShort", comment: "")
        case .tuesday:
            return NSLocalizedString("tuesdayShort", comment: "")
        case .wednesday:
            return NSLocalizedString("wednesdayShort", comment: "")
        case .thursday:
            return NSLocalizedString("thursdayShort", comment: "")
        case .friday:
            return NSLocalizedString("fridayShort", comment: "")
        case .saturday:
            return NSLocalizedString("saturdayShort", comment: "")
        case .sunday:
            return NSLocalizedString("sundayShort", comment: "")
        }
    }
    
    var orderNumber: Int {
        switch self {
        case .monday:
            return 1
        case .tuesday:
            return 2
        case .wednesday:
            return 3
        case .thursday:
            return 4
        case .friday:
            return 5
        case .saturday:
            return 6
        case .sunday:
            return 7
        }
    }
    
    static func convert(from shortNameOfDay: String) -> Weekday {
        switch shortNameOfDay {
        case NSLocalizedString("mondayShort", comment: ""):
            return .monday
        case NSLocalizedString("tuesdayShort", comment: ""):
            return .tuesday
        case NSLocalizedString("wednesdayShort", comment: ""):
            return .wednesday
        case NSLocalizedString("thursdayShort", comment: ""):
            return .thursday
        case NSLocalizedString("fridayShort", comment: ""):
            return .friday
        case NSLocalizedString("saturdayShort", comment: ""):
            return .saturday
        case NSLocalizedString("sundayShort", comment: ""):
            return .sunday
        default:
            return .monday
        }
    }
}
