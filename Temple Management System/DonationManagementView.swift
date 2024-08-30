//
//  DonationManagementView.swift
//  Temple Management System
//
//  Created by Ripal Shah on 8/29/24.
//

import SwiftUI
import CoreData

struct DonationManagementView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Donation.date, ascending: false)],
        animation: .default)
    private var donations: FetchedResults<Donation>
    
    @State private var showingAddDonationView = false

    var body: some View {
        NavigationView {
            List {
                ForEach(donations) { donation in
                    NavigationLink(destination: DonationDetailView(donation: donation)) {
                        DonationRow(donation: donation)
                    }
                }
                .onDelete(perform: deleteDonations)
            }
            .navigationTitle("Donation Management")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddDonationView = true }) {
                        Label("Add Donation", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddDonationView) {
                NavigationView {
                    DonationDetailView(donation: Donation(context: viewContext))
                        .environment(\.managedObjectContext, viewContext)
                }
            }
        }
    }

    private func deleteDonations(offsets: IndexSet) {
        withAnimation {
            offsets.map { donations[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct DonationManagementView_Previews: PreviewProvider {
    static var previews: some View {
        DonationManagementView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

