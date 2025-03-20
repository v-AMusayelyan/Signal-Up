//
//  LanguageSettingsView.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 18.03.25.
//

import SwiftUI

struct LanguageSettingsView: View {
    @Binding var selectedLanguage: Int
    
    var body: some View {
        List {
            ForEach(0..<3) { index in
                Button(action: {
                    selectedLanguage = index
                }) {
                    HStack {
                        Text(["English", "Spanish", "French"][index])
                        Spacer()
                        if selectedLanguage == index {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        }
        .navigationTitle("Language Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    LanguageSettingsView(selectedLanguage: .constant(1))
}
