//
//  CustomTabView.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 17.03.25.
//

import SwiftUI

struct CustomTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Tab.allCases, id: \.self) { tab in
                NavigationStack {
                    tabViewContent(for: tab)
                        .navigationTitle(tab.title)
                        .navigationBarTitleDisplayMode(.inline)
                }
                .tabItem {
                    Image(systemName: selectedTab == tab ? tab.filledIcon : tab.icon)
                        .environment(\.symbolVariants, selectedTab == tab ? .fill : .none)
                    Text(tab.title)
                }
                .tag(tab)
            }
        }
    }
    
    @ViewBuilder
    private func tabViewContent(for tab: Tab) -> some View {
        switch tab {
        case .home:
            HomeView(appState: appState)
        case .chart:
            Text("chart")
        case .history:
            Text("history")
        case .discover:
            Text("discover")
        case .settings:
            SettingsView()
        }
    }
}

#Preview {
    CustomTabView()
        .environmentObject(
            AppState(signalState: .upState, price: 100, percentage: 20, name: "Solana", isSignalUp: true))
}
