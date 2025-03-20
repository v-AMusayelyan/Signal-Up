//
//  DateFormatSettingsView.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 18.03.25.
//

import SwiftUI

struct DateFormatSettingsView: View {
    var body: some View {
        List {
            ForEach(0..<3) { index in
                Button(action: {
                    // Handle date format change here
                }) {
                    HStack {
                        Text(["MM/dd/yyyy", "dd/MM/yyyy", "yyyy/MM/dd"][index])
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Date Format Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DateFormatSettingsView()
}
