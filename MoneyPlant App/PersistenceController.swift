//
//  PersistenceController.swift
//  MoneyPlant App
//
//  Created by admin86 on 02/11/24.
//

import Foundation
import CoreData

class PersistenceController {
    
    private init() {}
    static let shared = PersistenceController()

    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MoneyPlant_App")
        
        if let storeURL = container.persistentStoreDescriptions.first?.url {
            let fileManager = FileManager.default
            do {
                if fileManager.fileExists(atPath: storeURL.path) {
                    try fileManager.removeItem(at: storeURL) // Delete the store file
                    print("Old persistent store deleted.")
                }
            } catch {
                print("Failed to delete persistent store: \(error)")
            }
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()


    
    // MARK: - Core Data Saving support
    lazy var context = persistentContainer.viewContext
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}





