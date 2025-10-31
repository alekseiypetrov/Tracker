struct Day {
    let fullName: String
    let shortName: String
    let orderNumber: Int
    
    init(weekday: Weekday?) {
        guard let weekday = weekday else {
            fullName = ""
            shortName = ""
            orderNumber = 0
            return
        }
        switch weekday {
        case .monday:
            fullName = "Понедельник"
            shortName = "Пн"
            orderNumber = 1
        case .tuesday:
            fullName = "Вторник"
            shortName = "Вт"
            orderNumber = 2
        case .wednesday:
            fullName = "Среда"
            shortName = "Ср"
            orderNumber = 3
        case .thursday:
            fullName = "Четверг"
            shortName = "Чт"
            orderNumber = 4
        case .friday:
            fullName = "Пятница"
            shortName = "Пт"
            orderNumber = 5
        case .saturday:
            fullName = "Суббота"
            shortName = "Сб"
            orderNumber = 6
        case .sunday:
            fullName = "Воскресенье"
            shortName = "Вс"
            orderNumber = 7
        }
    }
    
    static func convert(from string: String) -> Weekday {
        switch string {
        case "Пн":
            return .monday
        case "Вт":
            return .tuesday
        case "Ср":
            return .wednesday
        case "Чт":
            return .thursday
        case "Пт":
            return .friday
        case "Сб":
            return .saturday
        case "Вс":
            return .sunday
        default:
            return .monday
        }
    }
}
