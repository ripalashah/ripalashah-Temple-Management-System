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

        // Create a mock donation for preview
        let newDonation = Donation(context: viewContext)
        newDonation.donorName = "Sample Donor"
        newDonation.amount = 100.0
        newDonation.donationCategory = "Category"
        newDonation.donationType = DonationType.cash.rawValue
        newDonation.date = Date()
        newDonation.phone = "123-456-7890"
        newDonation.city = "City"
        newDonation.state = "State"
        newDonation.country = "Country"

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

        return result
    }()
}


