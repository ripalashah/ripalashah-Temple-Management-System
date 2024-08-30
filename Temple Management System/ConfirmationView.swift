//
//  ConfirmationView.swift
//  Temple Management System
//
//  Created by Ripal Shah on 8/29/24.
//

import SwiftUI

struct ConfirmationView: View {
    var message: String

    var body: some View {
        VStack {
            Text(message)
                .font(.title)
                .padding()
            // Add any additional UI elements or styling here
        }
        .navigationTitle("Confirmation")
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(message: "Donation saved successfully!")
    }
}
