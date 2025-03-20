//
//  NotificationSettingsView.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 18.03.25.
//

import SwiftUI

struct NotificationSettingsView: View {
    var body: some View {
        List {
            Text("Manage your notification preferences here.")
                .padding()
        }
        .navigationTitle("Notification Preferences")
        .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview {
    NotificationSettingsView()
}
