struct Day {
    let fullName: String
    let shortName: String
    
    init(weekday: Weekday?) {
        guard let weekday = weekday else {
            fullName = ""
            shortName = ""
            return
        }
        switch weekday {
        case .monday:
            fullName = "Понедельник"
            shortName = "Пн"
        case .tuesday:
            fullName = "Вторник"
            shortName = "Вт"
        case .wednesday:
            fullName = "Среда"
            shortName = "Ср"
        case .thursday:
            fullName = "Четверг"
            shortName = "Чт"
        case .friday:
            fullName = "Пятница"
            shortName = "Пт"
        case .saturday:
            fullName = "Суббота"
            shortName = "Сб"
        case .sunday:
            fullName = "Воскресенье"
            shortName = "Вс"
        }
    }
}
