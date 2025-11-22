final class ChooseCategoryViewModel {
    var categoriesBinding: Binding<[String]>?
    
    private let categoryStore: TrackerCategoryStore
    private(set) var categories: [String] = [] {
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
    
    private func getCategories() -> [String] {
        categoryStore.getTitlesOfCategories()
    }
}

extension ChooseCategoryViewModel: TrackerCategoryStoreDelegate {
    func didUpdated(_ updates: CategoryUpdateValues) {
        categories = getCategories()
    }
}
