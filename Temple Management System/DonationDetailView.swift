//
//  DonationDetailView.swift
//  Temple Management System
//
//  Created by Ripal Shah on 8/30/24.
//

//
//  DonationDetailView.swift
//  Temple Management System
//
//  Created by Ripal Shah on 8/30/24.
//

//
//  DonationDetailView.swift
//  Temple Management System
//
//  Created by Ripal Shah on 8/30/24.
//

import SwiftUI
import CoreData

enum DonationType: String, CaseIterable, Identifiable {
    case cash = "Cash"
    case product = "Product"
    case creditCard = "Credit Card"
    case zelle = "Zelle"
    case check = "Check"

    var id: String { self.rawValue }
}

struct DonationDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isEditing: Bool = false
    @State private var donorName: String
    @State private var amount: String
    @State private var donationCategory: String
    @State private var donationType: DonationType
    @State private var date: Date
    @State private var phone: String
    @State private var city: String
    @State private var state: String
    @State private var country: String
    @State private var showSaveConfirmation: Bool = false
    @State private var submissionMessage: String = ""

    let donation: Donation

    init(donation: Donation) {
        _donorName = State(initialValue: donation.donorName ?? "")
        _amount = State(initialValue: String(donation.amount))
        _donationCategory = State(initialValue: donation.donationCategory ?? "")
        _donationType = State(initialValue: DonationType(rawValue: donation.donationType ?? "") ?? .cash)
        _date = State(initialValue: donation.date ?? Date())
        _phone = State(initialValue: donation.phone ?? "")
        _city = State(initialValue: donation.city ?? "")
        _state = State(initialValue: donation.state ?? "")
        _country = State(initialValue: donation.country ?? "")
        self.donation = donation
    }

    var body: some View {
        Form {
            Section(header: Text("Donor Information")) {
                if isEditing {
                    TextField("Donor Name", text: $donorName)
                    TextField("Phone", text: $phone)
                    TextField("City", text: $city)
                    TextField("State", text: $state)
                    TextField("Country", text: $country)
                } else {
                    Text("Donor: \(donorName)")
                    Text("Phone: \(phone)")
                    Text("City: \(city)")
                    Text("State: \(state)")
                    Text("Country: \(country)")
                }
            }

            Section(header: Text("Donation Details")) {
                if isEditing {
                    TextField("Donation Category", text: $donationCategory)
                    Picker("Donation Type", selection: $donationType) {
                        ForEach(DonationType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                } else {
                    Text("Category: \(donationCategory)")
                    Text("Type: \(donationType.rawValue)")
                    Text("Amount: $\(amount)")
                    Text("Date: \(formattedDate(date))")
                }
            }
        }
        .navigationTitle("Donation Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isEditing {
                    Button("Save") {
                        saveChanges()
                    }
                } else {
                    Button("Edit") {
                        isEditing = true
                    }
                }
            }
        }
        .alert(isPresented: $showSaveConfirmation) {
            Alert(title: Text(submissionMessage))
        }
    }

    private func saveChanges() {
        donation.donorName = donorName
        donation.amount = Double(amount) ?? 0.0
        donation.donationCategory = donationCategory
        donation.donationType = donationType.rawValue
        donation.date = date
        donation.phone = phone
        donation.city = city
        donation.state = state
        donation.country = country

        do {
            try viewContext.save()
            submissionMessage = "Donation saved successfully!"
        } catch {
            submissionMessage = "Error saving donation: \(error.localizedDescription)"
        }

        showSaveConfirmation = true
        isEditing = false
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct DonationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a mock donation object for the preview
        let mockDonation = Donation(context: PersistenceController.preview.container.viewContext)
        mockDonation.donorName = "John Doe"
        mockDonation.amount = 100.0
        mockDonation.donationCategory = "Food"
        mockDonation.donationType = DonationType.cash.rawValue
        mockDonation.date = Date()
        mockDonation.phone = "555-555-5555"
        mockDonation.city = "New York"
        mockDonation.state = "NY"
        mockDonation.country = "USA"

        return NavigationView {
            DonationDetailView(donation: mockDonation)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
