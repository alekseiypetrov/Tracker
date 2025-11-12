import CoreData
import UIKit

final class TrackerStore: NSObject {
    
    private var insertionHandler: ((Result<IndexPath, Error>) -> Void)?
    private let categoryStore: TrackerCategoryStoreProtocol
    private let context: NSManagedObjectContext
    private lazy var fetchResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "category.title", ascending: true),
            NSSortDescriptor(key: "name", ascending: true),
        ]
        
        let fetchResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: "category.title",
            cacheName: nil)
        fetchResultsController.delegate = self
        try? fetchResultsController.performFetch()
        return fetchResultsController
    }()
    
    override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.context = context
        self.categoryStore = TrackerCategoryStore()
        super.init()
    }
    
    func addTracker(fromObject tracker: Tracker, toCategory category: String, handler: @escaping ((Result<IndexPath, Error>)) -> ()) {
        switch findExistingTracker(withTitle: tracker.name) {
        case .success(_):
            handler(.failure(CoreDataError.duplicatingValue("Категория с таким именем уже существует!")))
        case .failure(_):
            do {
                let category = try categoryStore.getCategory(withTitle: category)
                let newTracker = TrackerCoreData(context: context)
                newTracker.id = Int64(tracker.id)
                newTracker.name = tracker.name
                newTracker.emoji = tracker.emoji
                newTracker.color = tracker.color
                newTracker.category = category
                self.insertionHandler = handler
                try? context.save()
            } catch {
                handler(.failure(error))
                return
            }
        }
    }
    
    func getNumberOfAllTrackers() -> Int? {
        fetchResultsController.sections?.reduce(0, { $0 + $1.numberOfObjects })
    }
    
    private func findExistingTracker(withTitle title: String) -> Result<TrackerCoreData, CoreDataError> {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", title)
        guard let existingTracker = try? context.fetch(fetchRequest).first
        else {
            return .failure(CoreDataError.nonExistantValue("Трекер с таким именем не существует"))
        }
        return .success(existingTracker)
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            insertionHandler?(.success(indexPath))
            insertionHandler = nil
        default:
            fatalError()
        }
    }
}
