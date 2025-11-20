final class ChooseCategoryTableViewCellViewModel {
    let title: String
    private(set) var isSelected: Bool
    
    var titleBinding: Binding<String>? {
        didSet {
            titleBinding?(title)
        }
    }
    
    var isSelectedBinding: Binding<Bool>? {
        didSet {
            isSelectedBinding?(isSelected)
        }
    }
    
    init(title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }
    
    func setSelected(_ selected: Bool) {
        self.isSelected = selected
        isSelectedBinding?(selected)
    }
}
