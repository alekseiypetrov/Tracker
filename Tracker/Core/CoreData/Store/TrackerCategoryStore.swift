import CoreData
import UIKit

protocol TrackerCategoryStoreProtocol: AnyObject {
    func getCategory(withTitle title: String) throws -> TrackerCategoryCoreData
}

final class TrackerCategoryStore: NSObject {
    
    private var insertedIndex: Int?
    private let context: NSManagedObjectContext
    private lazy var fetchResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
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
    
    func getNumberOfCategories() -> Int {
        fetchResultsController.fetchedObjects?.count ?? 0
    }
    
    func getTitlesOfCategories() -> [String] {
        guard let objects = fetchResultsController.fetchedObjects else { return [] }
        return objects.compactMap( { $0.title } )
    }
    
    func addCategory(withTitle title: String, handler: @escaping ((Result<Int, Error>)) -> ()) {
        switch findExistingCategory(withTitle: title) {
        case .failure(_):
            let newTrackerCategory = TrackerCategoryCoreData(context: context)
            newTrackerCategory.title = title
            try? context.save()
            handler(.success(insertedIndex!))
        case .success(_):
            handler(.failure(CoreDataError.duplicatingValue("Категория с таким именем уже существует")))
        }
    }
    
    private func findExistingCategory(withTitle title: String) -> Result<TrackerCategoryCoreData, CoreDataError> {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        if let existingCategory = try? context.fetch(request).first {
            return .success(existingCategory)
        }
        return .failure(CoreDataError.nonExistantValue("Категория с таким именем не существует"))
    }
}

extension TrackerCategoryStore: TrackerCategoryStoreProtocol {
    func getCategory(withTitle title: String) throws -> TrackerCategoryCoreData {
        switch findExistingCategory(withTitle: title) {
        case .failure(let error):
            throw error
        case .success(let category):
            return category
        }
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            insertedIndex = indexPath.item
        case .update:
            return
        default:
            fatalError()
        }
    }
    
    func object(at indexPath: IndexPath) -> TrackerCategoryCoreData {
        fetchResultsController.object(at: indexPath)
    }
}
