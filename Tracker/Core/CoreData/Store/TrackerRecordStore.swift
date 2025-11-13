import CoreData
import UIKit

final class TrackerRecordStore: NSObject {
    
    private let context: NSManagedObjectContext
    private let saveContext: () -> ()
    
    override init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        self.saveContext = appDelegate.saveContext
        super.init()
    }
    
    func addRecord(fromObjectWithId id: UInt, atDate date: String) {
        let newRecord = TrackerRecordCoreData(context: context)
        newRecord.id = Int64(id)
        newRecord.date = date
        saveContext()
    }
    
    func deleteRecord(fromObjectWithId id: UInt, atDate date: String) throws {
        guard let record = getSpecificRecord(withId: id, atDate: date)
        else { throw CoreDataError.nonExistantValue("Данной записи нет в базе") }
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
    
    private func getSpecificRecord(withId id: UInt, atDate date: String) -> TrackerRecordCoreData? {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %ld AND date == %@", id, date)
        guard let result = try? context.fetch(fetchRequest)
        else { return nil }
        return result.first
    }
}
