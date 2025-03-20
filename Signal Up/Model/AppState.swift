//
//  AppState.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 03.03.25.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var id: String = ""
    @Published var signalState: SignalState
    @Published var price: Double
    @Published var percentage: Double
    @Published var name: String
    @Published var isSignalUp: Bool
    
    init(signalState: SignalState, price: Double, percentage: Double, name: String, isSignalUp: Bool) {
        self.signalState = signalState
        self.price = price
        self.percentage = percentage
        self.name = name
        self.isSignalUp = isSignalUp
    }
}

enum SignalState {
    case defaultState
    case upState
    case downState
}
