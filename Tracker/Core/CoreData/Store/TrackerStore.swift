import CoreData
import UIKit

protocol TrackerStoreDelegate: AnyObject {
    func didUpdated()
}

protocol TrackerStoreProtocol: AnyObject {
    func findTracker(withId id: Int64) -> Result<TrackerCoreData, CoreDataError>
}

final class TrackerStore: NSObject, NSFetchedResultsControllerDelegate {
    
    private weak var delegate: TrackerStoreDelegate?
    private let context: NSManagedObjectContext
    private let saveContext: () -> ()
    
    init(delegate: TrackerStoreDelegate) {
        self.context = DataBaseStore.shared.persistentContainer.viewContext
        self.saveContext = DataBaseStore.shared.saveContext
        self.delegate = delegate
    }
    
    func deleteTracker(fromObject tracker: Tracker) throws {
        // TODO: - Will be done later (логика поиска и удаления трекера из БД) -- протестить
        switch findExistingTracker(withTitle: tracker.name) {
        case .failure(let error):
            throw error
        case .success(let trackerCoreData):
            context.delete(trackerCoreData)
            saveContext()
            delegate?.didUpdated()
        }
    }
    
    func updateTracker(fromObject tracker: Tracker, toCategory category: String, categoryStore: TrackerCategoryStoreProtocol) throws {
        switch findTracker(withId: Int64(tracker.id)) {
        case .failure(let error):
            throw error
        case .success(let trackerCoreData):
            do {
                let category = try categoryStore.getCategory(withTitle: category)
                trackerCoreData.name = tracker.name
                trackerCoreData.emoji = tracker.emoji
                trackerCoreData.color = tracker.color
                trackerCoreData.timetable = tracker.timetable as NSArray
                trackerCoreData.category = category
                saveContext()
                delegate?.didUpdated()
            } catch CoreDataError.nonExistentValue(let message) {
                throw CoreDataError.nonExistentValue(message)
            } catch {
                throw error
            }
        }
    }
    
    func addTracker(fromObject tracker: Tracker, toCategory category: String, categoryStore: TrackerCategoryStoreProtocol) throws {
        switch findExistingTracker(withTitle: tracker.name) {
        case .success:
            throw CoreDataError.duplicatingValue(NSLocalizedString("duplicatingTracker", comment: ""))
        case .failure:
            do {
                let category = try categoryStore.getCategory(withTitle: category)
                let newTracker = TrackerCoreData(context: context)
                newTracker.id = Int64(tracker.id)
                newTracker.name = tracker.name
                newTracker.emoji = tracker.emoji
                newTracker.color = tracker.color
                newTracker.timetable = tracker.timetable as NSArray
                newTracker.category = category
                saveContext()
                delegate?.didUpdated()
            } catch CoreDataError.nonExistentValue(let message) {
                throw CoreDataError.nonExistentValue(message)
            } catch {
                throw error
            }
        }
    }
    
    func getNumberOfAllTrackers() -> Int? {
        let request = TrackerCoreData.fetchRequest()
        request.resultType = .countResultType
        guard let numberOfTrackers = try? context.count(for: request)
        else { return nil }
        return numberOfTrackers
    }
    
    private func findExistingTracker(withTitle title: String) -> Result<TrackerCoreData, CoreDataError> {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", title)
        guard let existingTracker = try? context.fetch(request).first
        else {
            return .failure(CoreDataError.nonExistentValue(NSLocalizedString("nonExistentTracker", comment: "")))
        }
        return .success(existingTracker)
    }
}

extension TrackerStore: TrackerStoreProtocol {
    func findTracker(withId id: Int64) -> Result<TrackerCoreData, CoreDataError> {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %ld", id)
        guard let existingTracker = try? context.fetch(request).first
        else {
            return .failure(CoreDataError.nonExistentValue(NSLocalizedString("nonExistentTrackerWithId", comment: "")))
        }
        return .success(existingTracker)
    }
}
