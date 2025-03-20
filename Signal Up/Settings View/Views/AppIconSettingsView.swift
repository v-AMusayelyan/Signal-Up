//
//  AppIconSettingsView.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 18.03.25.
//

import SwiftUI

struct AppIconSettingsView: View {
    var body: some View {
        List {
            Text("Choose App Icon")
                .foregroundColor(.blue)
        }
        .navigationTitle("App Icon Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AppIconSettingsView()
}
