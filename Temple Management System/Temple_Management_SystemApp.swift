//
//  Temple_Management_SystemApp.swift
//  Temple Management System
//
//  Created by Ripal Shah on 8/29/24.

import SwiftUI

@main
struct Temple_Management_SystemApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
