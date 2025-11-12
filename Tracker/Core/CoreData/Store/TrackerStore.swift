import CoreData
import UIKit

final class TrackerStore: NSObject, NSFetchedResultsControllerDelegate {
    
    // weak var delegate: TrackerStoreDelegate?
    private let categoryStore: TrackerCategoryStoreProtocol
    private let context: NSManagedObjectContext
    private lazy var fetchResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "category.title", ascending: true)
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
    
    func addTracker(fromObject tracker: Tracker, toCategory category: String, handler: ((Result<Void, Error>)) -> ()) {
        switch findExistingTracker(withTitle: tracker.name) {
        case .success(_):
            handler(.failure(CoreDataError.duplicatingValue("Категория с таким именем уже существует!")))
        case .failure(_):
            do {
                var category = try categoryStore.getCategory(withTitle: category)
                var newTracker = TrackerCoreData(context: context)
                newTracker.id = Int64(tracker.id)
                newTracker.name = tracker.name
                newTracker.emoji = tracker.emoji
                newTracker.color = tracker.color
                newTracker.category = category
                try? context.save()
                handler(.success(Void()))
            } catch {
                handler(.failure(error))
            }
        }
    }
    
    func getNumberOfTrackers(inSection section: Int) -> Int {
        fetchResultsController.sections?[section].numberOfObjects ?? 0
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
