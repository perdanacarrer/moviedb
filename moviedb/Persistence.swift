//
//  Persistence.swift
//  moviedb
//
//  Created by oscar perdana on 15/06/24.
//

import Foundation
import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "moviedb")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
