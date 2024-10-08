//
//  DonationListView.swift
//  Temple Management System
//
//  Created by Ripal Shah on 8/30/24.
//

import SwiftUI
import CoreData

struct DonationListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Donation.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Donation.date, ascending: false)]
    ) var donations: FetchedResults<Donation>

    var body: some View {
        NavigationStack {
            List {
                ForEach(donations) { donation in
                    NavigationLink(destination: DonationDetailView(donation: donation)) {
                        DonationRow(donation: donation)
                    }
                }
                .onDelete(perform: deleteDonations)
            }
            .navigationTitle("Donations List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addDonation) {
                        Label("Add Donation", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addDonation() {
        withAnimation {
            let newDonation = Donation(context: viewContext)
            newDonation.id = UUID()
            newDonation.date = Date()
            // Set other initial values as needed

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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

struct DonationListView_Previews: PreviewProvider {
    static var previews: some View {
        DonationListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

