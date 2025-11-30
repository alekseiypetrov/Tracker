import CoreData
import UIKit

final class TrackerRecordStore: NSObject {
    
    private let context: NSManagedObjectContext
    private let saveContext: () -> ()
    
    override init() {
        self.context = DataBaseStore.shared.persistentContainer.viewContext
        self.saveContext = DataBaseStore.shared.saveContext
        super.init()
    }
    
    func addRecord(fromObjectWithId id: UInt, atDate date: String, trackerStore: TrackerStoreProtocol) {
        guard let tracker = try? trackerStore.findTracker(withId: Int64(id)).get()
        else { return }
        let newRecord = TrackerRecordCoreData(context: context)
        newRecord.id = Int64(id)
        newRecord.date = date
        newRecord.tracker = tracker
        saveContext()
    }
    
    func deleteRecord(fromObjectWithId id: UInt, atDate date: String) throws {
        guard let record = getSpecificRecord(withId: id, atDate: date)
        else { throw CoreDataError.nonExistentValue(NSLocalizedString("nonExistentRecord", comment: "")) }
        context.delete(record)
        saveContext()
    }
    
    func getNumberOfRecords(ofTrackerWithId id: UInt) -> Int {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %ld", id)
        guard let numberOfRecords = try? context.fetch(fetchRequest).count
        else { return 0 }
        return numberOfRecords
    }
    
    func getStatusOfTracker(withId id: UInt, atDate date: String) -> Bool {
        getSpecificRecord(withId: id, atDate: date) != nil
    }
    
    func getNumberOfRecordsGroupedByTheDate() -> [String: Int] {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        guard let records = try? context.fetch(fetchRequest)
        else { return [:] }
        return Dictionary(grouping: records) { $0.date ?? "" }
            .mapValues { $0.count }
    }
    
    private func getSpecificRecord(withId id: UInt, atDate date: String) -> TrackerRecordCoreData? {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %ld AND date == %@", id, date)
        guard let result = try? context.fetch(fetchRequest)
        else { return nil }
        return result.first
    }
}
