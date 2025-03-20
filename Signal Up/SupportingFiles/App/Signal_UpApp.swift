//
//  Signal_UpApp.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 25.02.25.
//

import SwiftUI
import UserNotifications

@main
struct Signal_UpApp: App {
    @StateObject private var appState = AppState(signalState: .upState, price: 0.00, percentage: 0.00, name: "Test", isSignalUp: true)
    
    init() {
        requestNotificationAuthorization()
        registerForRemoteNotifications()
    }
    
    // MARK: - Request Notification Authorization
    private func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Register for Remote Notifications
    private func registerForRemoteNotifications() {
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .onOpenURL { url in
                    handleURL(url)
                }
        }
    }
    
    private func handleURL(_ url: URL) {
        guard let urlComponents = URLComponents(string: url.absoluteString) else {
            print("Invalid URL: \(url)")
            return
        }
        
        // Extract the data from the URL
        if let price = urlComponents.queryItems?.first(where: { $0.name == "price" })?.value,
           let percentage = urlComponents.queryItems?.first(where: { $0.name == "percentage" })?.value,
           let name = urlComponents.queryItems?.first(where: { $0.name == "name" })?.value,
           let isSignalUpString = urlComponents.queryItems?.first(where: { $0.name == "isSignalUp" })?.value,
           let id = urlComponents.queryItems?.first(where: { $0.name == "id" })?.value {
            
            print("Id: \(id)")
            print("Price: \(price)")
            print("Percentage: \(percentage)")
            print("Name: \(name)")
            print("isSignalUp: \(isSignalUpString)")
            
            let isSignalUp = isSignalUpString.lowercased() == "true"
            
            DispatchQueue.main.async {
                appState.id = id
                appState.price = Double(price) ?? 0
                appState.percentage = Double(percentage) ?? 0
                appState.name = name
                appState.isSignalUp = isSignalUp
                appState.signalState = isSignalUp ? .upState : .downState
            }
        }
    }
}
