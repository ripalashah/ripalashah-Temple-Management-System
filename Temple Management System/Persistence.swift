//
//  Persistence.swift
//  Temple Management System
//
//  Created by Ripal Shah on 8/29/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Temple_Management_System")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create sample data here if needed
        // let newDonation = Donation(context: viewContext)
        // newDonation.someProperty = "Some Value"
        
        do {
            try viewContext.save()
        } catch {
            fatalError("Unresolved error \(error)")
        }
        
        return result
    }()
}
