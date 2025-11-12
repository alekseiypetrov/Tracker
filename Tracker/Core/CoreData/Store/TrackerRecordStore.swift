import CoreData
import UIKit

final class TrackerRecordStore: NSObject {
    
    private let context: NSManagedObjectContext
    
    override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.context = context
        super.init()
    }
    
    func addRecord(fromObjectWithId id: UInt, atDate date: String) {
        let newRecord = TrackerRecordCoreData(context: context)
        newRecord.id = Int64(id)
        newRecord.date = date
        try? context.save()
    }
    
    func deleteRecord(fromObjectWithId id: UInt, atDate date: String, handler: @escaping ((Result<Void, Error>)) -> ()) {
        if let record = getSpecificRecord(withId: id, atDate: date) {
            context.delete(record)
            try? context.save()
            return handler(.success(Void()))
        }
        return handler(.failure(CoreDataError.nonExistantValue("Данной записи нет в базе")))
    }
    
    func getNumberOfRecords(ofTrackerWithId id: UInt) -> Int {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %ld", id)
        guard let numberOfRecords = try? context.fetch(fetchRequest).count
        else { return 0 }
        return numberOfRecords
    }
    
    func getStatusOfTracker(withId id: UInt, atDate date: String, handler: @escaping (Bool) -> ()) {
        guard getSpecificRecord(withId: id, atDate: date) != nil
        else { return handler(false) }
        return handler(true)
    }
    
    private func getSpecificRecord(withId id: UInt, atDate date: String) -> TrackerRecordCoreData? {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %ld AND date == %K", id,
                                             #keyPath(TrackerRecordCoreData.date), date)
        guard let result = try? context.fetch(fetchRequest)
        else { return nil }
        return result.first
    }
}
