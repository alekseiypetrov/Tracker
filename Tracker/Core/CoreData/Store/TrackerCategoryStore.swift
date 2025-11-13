import CoreData
import UIKit

protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdated(_ updates: CategoryUpdateValues)
}

protocol TrackerCategoryStoreProtocol: AnyObject {
    func getCategory(withTitle title: String) throws -> TrackerCategoryCoreData
}

struct CategoryUpdateValues {
    let insertedIndexes: [IndexPath]
    let deletedIndexes: [IndexPath]
}

final class TrackerCategoryStore: NSObject {
    
    private var insertedIndexes: [IndexPath]?
    private var deletedIndexes: [IndexPath]?
    private let delegate: TrackerCategoryStoreDelegate?
    private let context: NSManagedObjectContext
    private let saveContext: () -> ()
    
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
    
    init(delegate: TrackerCategoryStoreDelegate) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        self.saveContext = appDelegate.saveContext
        self.delegate = delegate
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
    
    func addCategory(withTitle title: String) throws {
        switch findExistingCategory(withTitle: title) {
        case .failure(_):
            let newTrackerCategory = TrackerCategoryCoreData(context: context)
            newTrackerCategory.title = title
            saveContext()
        case .success(_):
            throw CoreDataError.duplicatingValue("Категория с таким именем уже существует")
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
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = []
        deletedIndexes = []
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdated(CategoryUpdateValues(
            insertedIndexes: insertedIndexes ?? [],
            deletedIndexes: deletedIndexes ?? []))
        insertedIndexes = nil
        deletedIndexes = nil
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { return }
            insertedIndexes?.append(indexPath)
        case .delete:
            guard let indexPath = newIndexPath else { return }
            deletedIndexes?.append(indexPath)
        default:
            return
        }
    }
    
    func object(at indexPath: IndexPath) -> TrackerCategoryCoreData {
        fetchResultsController.object(at: indexPath)
    }
}
