import CoreData
import UIKit

enum CoreDataError: Error {
    case duplicatingValue(String)
}

final class TrackerCategoryStore: NSObject {
    
    private let context: NSManagedObjectContext
    private lazy var fetchResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        
        let fetchResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchResultsController.delegate = self
        try? fetchResultsController.performFetch()
        return fetchResultsController
    }()
    
    override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.context = context
        super.init()
    }
    
    func getCategories() -> [TrackerCategory] {
        guard let objects = fetchResultsController.fetchedObjects else { return [] }
        return objects.compactMap( { TrackerCategory.convert(from: $0) } )
    }
    
    func getTitlesOfCategories() -> [String] {
        guard let objects = fetchResultsController.fetchedObjects else { return [] }
        return objects.compactMap( { $0.title } )
    }
    
    func addCategory(withTitle title: String) throws {
        if findExistingCategory(withTitle: title) {
            throw CoreDataError.duplicatingValue("Категория с таким именем уже существует!")
        }
        var newTrackerCategory = TrackerCategoryCoreData(context: context)
        newTrackerCategory.title = title
        try? context.save()
    }
    
    private func findExistingCategory(withTitle title: String) -> Bool {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        if let existingCategory = try? context.fetch(request).first {
            return true
        }
        return false
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
}
