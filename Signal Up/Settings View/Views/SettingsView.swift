//
//  SettingsView.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 17.03.25.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel(
        userProfile: UserProfile(userName: "Aren Musayelyan", userEmail: "aren.musayelyan@solicy.net", walletAddress: "05da34358247ae33f8a0506f6d118a19ec08f2b9966823d951ab874d4883ec6a"),
        appSettings: AppSettings(
            isNotificationsEnabled: true,
            isLocationEnabled: false,
            selectedLanguage: 0,
            isDarkMode: false,
            isEmailNotificationsEnabled: true,
            isPushNotificationsEnabled: false,
            appVersion: "1.0.0",
            isFaceIDEnabled: false
        )
    )
    
    let languages = ["English", "Spanish", "French"]
    let dateFormats = ["MM/dd/yyyy", "dd/MM/yyyy", "yyyy/MM/dd"]
    
    var body: some View {
        List {
            Section(header: Text("Profile")) {
                NavigationLink(destination: ProfileSettingsView(userProfile: $viewModel.userProfile)) {
                    HStack {
                        Image(systemName: "brain.head.profile.fill")
                            .foregroundColor(.blue)
                        Text("Edit Profile")
                        Spacer()
                    }
                }
                
                HStack {
                    Image(systemName: "apple.logo")
                        .foregroundColor(.blue)
                    Text("App Version")
                    Spacer()
                    Text(viewModel.appSettings.appVersion)
                        .foregroundColor(.gray)
                }
            }
            
            Section(header: Text("Notifications")) {
                Toggle("Enable All Notifications", isOn: $viewModel.appSettings.isNotificationsEnabled.animation())
                
                if viewModel.appSettings.isNotificationsEnabled {
                    Toggle("Email Notifications", isOn: $viewModel.appSettings.isEmailNotificationsEnabled)
                        .transition(.opacity.combined(with: .opacity))
                    Toggle("Push Notifications", isOn: $viewModel.appSettings.isPushNotificationsEnabled)
                        .transition(.opacity.combined(with: .opacity))
                }
                
                NavigationLink(destination: NotificationSettingsView()) {
                    HStack {
                        Image(systemName: "bell.circle.fill")
                            .foregroundColor(.blue)
                        Text("Notification Preferences")
                        Spacer()
                    }
                }
            }
            
            Section(header: Text("General")) {
                HStack {
                    Image(systemName: "location.circle.fill")
                        .foregroundColor(.blue)
                    Spacer()
                    Toggle("Location Services", isOn: $viewModel.appSettings.isLocationEnabled)
                    
                }
                
                NavigationLink(destination: LanguageSettingsView(selectedLanguage: $viewModel.appSettings.selectedLanguage)) {
                    HStack {
                        Image(systemName: "globe")
                            .foregroundColor(.blue)
                        Text("Language")
                        Spacer()
                        Text(languages[viewModel.appSettings.selectedLanguage])
                            .foregroundColor(.gray)
                    }
                }
                NavigationLink(destination: DateFormatSettingsView()) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.blue)
                        Text("Date Format")
                        Spacer()
                        Text(dateFormats[viewModel.appSettings.selectedLanguage])
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Section(header: Text("Appearance")) {
                
                HStack {
                    Image(systemName: "circle.lefthalf.filled.inverse")
                        .foregroundColor(.blue)
                    Spacer()
                    Toggle("Dark Mode", isOn: $viewModel.appSettings.isDarkMode)
                }
                
                NavigationLink(destination: AppIconSettingsView()) {
                    HStack {
                        Image(systemName: "app.badge.fill")
                            .foregroundColor(.blue)
                        Text("App Icon")
                        Spacer()
                    }
                }
            }
            
            Section(header: Text("Privacy")) {
                NavigationLink(destination: AppIconSettingsView()) {
                    
                    HStack {
                        Image(systemName: "lock.shield.fill")
                            .foregroundColor(.blue)
                        Text("Privacy Policy")
                        Spacer()
                    }
                }
                NavigationLink(destination: AppIconSettingsView()) {
                    
                    HStack {
                        Image(systemName: "shield.fill")
                            .foregroundColor(.blue)
                        Text("Data Usage")
                        Spacer()
                    }
                }
            }
            
            Section(header: Text("Account")) {
                Button(action: {
                    print("Change Password tapped")
                }) {
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.blue)
                        Text("Change Password")
                        Spacer()
                        Image(systemName: "chevron.right.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
                Button(action: {
                    print("Logout tapped")
                }) {
                    Text("Log Out")
                        .foregroundColor(.red)
                }
            }
            
            Section(header: Text("Security")) {
                Toggle("Enable Face ID", isOn: $viewModel.appSettings.isFaceIDEnabled)
                    .onChange(of: viewModel.appSettings.isFaceIDEnabled) { value in
                        if value {
                            viewModel.enableFaceID()
                        } else {
                            viewModel.disableFaceID()
                        }
                    }
            }
        }
        .listStyle(GroupedListStyle())
    }
}
#Preview {
    NavigationView {
        SettingsView()
            .navigationTitle("Settings")
    }
}
