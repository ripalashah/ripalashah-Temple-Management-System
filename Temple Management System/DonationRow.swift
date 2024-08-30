//
//  DonationRow.swift
//  Temple Management System
//
//  Created by Ripal Shah on 8/30/24.
//

import SwiftUI

struct DonationRow: View {
    let donation: Donation

    var body: some View {
        VStack(alignment: .leading) {
            Text(donation.donorName ?? "Unknown Donor")
                .font(.headline)
            Text("Amount: \(donation.amount, specifier: "%.2f")")
                .font(.subheadline)
            Text("Type: \(donation.donationType ?? "Unknown")")
                .font(.subheadline)
            Text("Date: \(formattedDate(donation.date ?? Date()))")
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct DonationRow_Previews: PreviewProvider {
    static var previews: some View {
        let mockDonation = Donation(context: PersistenceController.preview.container.viewContext)
        mockDonation.donorName = "Jane Doe"
        mockDonation.amount = 200.0
        mockDonation.donationType = "Cash"
        mockDonation.date = Date()

        return DonationRow(donation: mockDonation)
            .previewLayout(.sizeThatFits)
    }
}




