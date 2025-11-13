import CoreData

final class DataBaseStore {
    
    // MARK: - Static properties
    
    static let shared = DataBaseStore()
    
    // MARK: - Initializers
    
    private init() { }
    
    // MARK: - CoreData Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ModelsCoreData")
        container.loadPersistentStores(completionHandler: { description, error in
            if let error = error as? NSError {
                assertionFailure("Error in creation of Persistent Container: \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - CoreData Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                assertionFailure("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
