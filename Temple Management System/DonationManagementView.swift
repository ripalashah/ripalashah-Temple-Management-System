//
//  DonationManagementView.swift
//  Temple Management System
//
//  Created by Ripal Shah on 8/29/24.
//

import SwiftUI
import CoreData

#if os(macOS)
import AppKit
#else
import UIKit
#endif

// Enum for DonationType with added types
enum DonationType: String, CaseIterable, Identifiable {
    case cash = "Cash"
    case product = "Product"
    case creditCard = "Credit Card"
    case zelle = "Zelle"
    case check = "Check"

    var id: String { self.rawValue }
}

#if os(iOS)
// Custom UIViewRepresentable for UITextField with decimal pad keyboard for iOS
struct DecimalTextField: UIViewRepresentable {
    var placeholder: String
    @Binding var text: String

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.keyboardType = .decimalPad
        textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: DecimalTextField

        init(_ parent: DecimalTextField) {
            self.parent = parent
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            // Ensure that the newString is a valid decimal number
            if let _ = NumberFormatter().number(from: newString) {
                parent.text = newString
                return true
            }
            return false
        }
    }
}
#endif

#if os(macOS)
// Custom NSViewRepresentable for NSTextField for macOS
struct DecimalTextField: NSViewRepresentable {
    var placeholder: String
    @Binding var text: String

    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.placeholderString = placeholder
        textField.delegate = context.coordinator
        return textField
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.stringValue = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: DecimalTextField

        init(_ parent: DecimalTextField) {
            self.parent = parent
        }

        func controlTextDidChange(_ obj: Notification) {
            if let textField = obj.object as? NSTextField {
                parent.text = textField.stringValue
            }
        }
    }
}
#endif

// Main View for Donation Management
struct DonationManagementView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var donorName: String = ""
    @State private var phone: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var country: String = ""
    @State private var donationCategory: String = ""
    @State private var donationType: DonationType = .cash
    @State private var amount: String = ""
    @State private var date = Date()
    @State private var submissionMessage: String = ""
    @State private var showConfirmation: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Donor Information")) {
                    TextField("Donor Name", text: $donorName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Phone", text: $phone)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        #if os(iOS)
                        .keyboardType(.phonePad)  // iOS-specific
                        #endif
                        .onChange(of: phone) { oldValue, newValue in
                            // Validate phone number format
                            phone = validatePhoneNumber(phone)
                        }

                    TextField("City", text: $city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("State", text: $state)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Country", text: $country)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                Section(header: Text("Donation Details")) {
                    TextField("Donation Category", text: $donationCategory)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Picker("Donation Type", selection: $donationType) {
                        ForEach(DonationType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    VStack {
                        DecimalTextField(placeholder: "Amount", text: $amount)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        DatePicker("Date", selection: $date, displayedComponents: .date)
                            .padding()
                    }
                }

                Button(action: saveDonation) {
                    Text("Save Donation")
                        .frame(maxWidth: .infinity, minHeight: 44) // Ensure the button has some size
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(isSaveDisabled)
            }
            .navigationTitle("Donation Management")
            .navigationDestination(isPresented: $showConfirmation) {
                ConfirmationView(message: submissionMessage)
            }
        }
    }

    var isSaveDisabled: Bool {
        donorName.isEmpty || phone.isEmpty || city.isEmpty || state.isEmpty || country.isEmpty || donationCategory.isEmpty || amount.isEmpty || !isValidAmount || !isValidPhone
    }

    var isValidAmount: Bool {
        // Validate that amount is a valid decimal number
        return NumberFormatter().number(from: amount) != nil
    }

    var isValidPhone: Bool {
        // Basic phone number validation
        let phoneRegex = "^[0-9]{10}$"  // Adjust as needed
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }

    func validatePhoneNumber(_ phoneNumber: String) -> String {
        // Validate and format phone number here if necessary
        return phoneNumber
    }

    func saveDonation() {
        guard validateInputs() else {
            submissionMessage = "All fields are required and amount must be valid."
            showConfirmation = true
            return
        }

        createDonation()
    }

    private func validateInputs() -> Bool {
        return !donorName.isEmpty && !phone.isEmpty && !city.isEmpty &&
               !state.isEmpty && !country.isEmpty && !donationCategory.isEmpty &&
               !amount.isEmpty && isValidAmount
    }

    private func createDonation() {
        let newDonation = Donation(context: viewContext)
        newDonation.id = UUID()
        newDonation.donorName = donorName
        newDonation.amount = Double(amount) ?? 0.0
        newDonation.date = date
        newDonation.donationCategory = donationCategory
        newDonation.donationType = donationType.rawValue
        newDonation.phone = phone
        newDonation.city = city
        newDonation.state = state
        newDonation.country = country

        do {
            try viewContext.save()
            submissionMessage = "Donation saved successfully!"
        } catch {
            submissionMessage = "Error saving donation: \(error.localizedDescription)"
        }

        showConfirmation = true
    }
}

struct DonationManagementView_Previews: PreviewProvider {
    static var previews: some View {
        DonationManagementView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

