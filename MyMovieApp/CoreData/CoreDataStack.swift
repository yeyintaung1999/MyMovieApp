

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    let persistenceContainer : NSPersistentContainer
    
    var context: NSManagedObjectContext {
        get {
            persistenceContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            return persistenceContainer.viewContext
        }
    }
    
    private init(){
        self.persistenceContainer = NSPersistentContainer(name: "MyMovieApp")
        
        persistenceContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data Couldn't load with error: \(error.localizedDescription)")
            }
        }
    }
    
    func saveContext(){
        let context = self.context
        if context.hasChanges {
            do{
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved Error \(error) \(error.userInfo)")
            }
        }
    }
    
}
