import CoreData

class DataController {

    static let sharedInstance = DataController()
    
    static var previewInstance: DataController = {
        let controller = DataController(useInMemoryStore: true)
        let context = controller.persistentContainer.viewContext
        return controller
    }()
    
    let persistentContainer: NSPersistentContainer
    
    init(useInMemoryStore: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "DataModel")
        if useInMemoryStore {
            if let storeDescription = persistentContainer.persistentStoreDescriptions.first {
                storeDescription.url = URL(fileURLWithPath: "/dev/null")
            } else {
                fatalError("Persistent store descriptions are missing")
            }
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error as NSError? {
                fatalError("Loading persistent stores failed: \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveContext(completion: @escaping (Error?) -> Void) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}
