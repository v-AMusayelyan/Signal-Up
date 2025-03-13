//
//  ContentView.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 25.02.25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        HomeView(appState: appState)
            .environmentObject(appState)
    }
}

#Preview {
    ContentView()
        .environmentObject(
            AppState(
                signalState: .upState,
                price: 100,
                percentage: 20,
                name: "Solana",
                isSignalUp: true
            )
        )
}
