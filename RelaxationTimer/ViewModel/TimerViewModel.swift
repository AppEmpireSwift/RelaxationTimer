import SwiftUI
import CoreData
import PhotosUI

class TimerViewModel: ObservableObject {
    @Published var timers: [TimerModel] = []
    @Published var newTimer: TimerModel = TimerModel(id: UUID(), name: "", time: "", color: .clear)
    @Published var activeSheet: ActiveSheet?
    @Published var isAlert = false
    
    private let viewContext = DataController.sharedInstance.persistentContainer.viewContext
    
    init() {
        fetch()
    }
    
    func fetch() {
        DispatchQueue.global(qos: .background).async {
            let fetchRequest: NSFetchRequest<TimerEntity> = TimerEntity.fetchRequest()
            
            do {
                let entities = try self.viewContext.fetch(fetchRequest)
                let healthRecords = entities.map { $0.toTimerModel() }
                
                DispatchQueue.main.async {
                    self.timers = healthRecords
                }
            } catch {
                print("Failed to fetch health records: \(error)")
            }
        }
    }
    
    func addNew() {
        let newRecord = TimerEntity(context: viewContext)
        newRecord.update(from: newTimer)
    
        saveChanges()
        reset()
        self.fetch()
    }
    
    func delete(timer: TimerModel) {
        let fetchRequest: NSFetchRequest<TimerEntity> = TimerEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", timer.id as CVarArg)
        
        do {
            let matchingEntities = try viewContext.fetch(fetchRequest)
            if let entityToDelete = matchingEntities.first {
                viewContext.delete(entityToDelete)
                saveChanges()
            } else {
                print("No matching record found to delete")
            }
        } catch {
            print("Error deleting record: \(error)")
        }
    }
    
    func saveChanges() {
        DataController.sharedInstance.saveContext { error in
            if let error = error {
                print("Error saving context: \(error)")
            } else {
                self.fetch()
            }
        }
    }
    
    func reset() {
        newTimer.id = UUID()
        newTimer.name = ""
        newTimer.time = ""
        newTimer.video = nil
        newTimer.sound = nil
        newTimer.image = nil
        newTimer.color = .clear
    }
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized {
                        self.activeSheet = .videoPicker
                    } else {
                        self.isAlert = true
                    }
                }
            }
        case .authorized:
            self.activeSheet = .videoPicker
        case .denied, .restricted:
            isAlert = true
        case .limited:
            self.activeSheet = .videoPicker
        @unknown default:
            isAlert = true
        }
    }
}
