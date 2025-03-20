//
//  SettingsViewModel.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 18.03.25.
//

import Foundation
import LocalAuthentication

class SettingsViewModel: ObservableObject {
    @Published var userProfile: UserProfile
    @Published var appSettings: AppSettings
    
    init(userProfile: UserProfile, appSettings: AppSettings) {
        self.userProfile = userProfile
        self.appSettings = appSettings
    }
    
    func enableFaceID() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate using Face ID") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        print("Face ID enabled successfully!")
                    } else {
                        print("Face ID authentication failed: \(authenticationError?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
        } else {
            print("Face ID not available: \(error?.localizedDescription ?? "Unknown error")")
        }
    }
    
    func disableFaceID() {
        print("Face ID has been disabled.")
    }
}
