//
//  ContentView.swift
//  Temple Management System
//
//  Created by Ripal Shah on 8/29/24.
//

//
//  ContentView.swift
//  Temple Management System
//
//  Created by Ripal Shah on 8/29/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to Temple Management")
                    .padding()
                
                NavigationLink(destination: DonationManagementView()
                    .environment(\.managedObjectContext, viewContext)) {
                    Text("Manage Donations")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Donation Management")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}



