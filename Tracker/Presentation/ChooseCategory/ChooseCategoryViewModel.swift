typealias Binding<T> = (T) -> ()

final class ChooseCategoryViewModel {
    var categoriesBinding: Binding<[ChooseCategoryTableViewCellViewModel]>?
    
    private let categoryStore: TrackerCategoryStore
    private(set) var categories: [ChooseCategoryTableViewCellViewModel] = [] {
        didSet {
            categoriesBinding?(categories)
        }
    }
    
    init(categoryStore: TrackerCategoryStore) {
        self.categoryStore = categoryStore
        self.categoryStore.delegate = self
        categories = getCategories()
    }
    
    func addCategory(withTitle title: String) throws {
        try categoryStore.addCategory(withTitle: title)
    }
    
    func updateSelectionStates(selectedCategory: String?) {
        guard let selectedCategory else { return }
        categories.forEach { $0.setSelected( selectedCategory == $0.title ) }
    }
    
    private func getCategories() -> [ChooseCategoryTableViewCellViewModel] {
        categoryStore.getTitlesOfCategories().map {
            ChooseCategoryTableViewCellViewModel(title: $0, isSelected: false)
        }
    }
}

extension ChooseCategoryViewModel: TrackerCategoryStoreDelegate {
    func didUpdated(_ updates: CategoryUpdateValues) {
        categories = getCategories()
    }
}
