//
//  SignalModel.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 10.03.25.
//

import Foundation

struct Signal {
    var name: String
    var price: Double
    var percentage: Double
    var isSignalUp: Bool
}

class SignalModel {
    static func generateRandomSignal() -> Signal {
        let randomBool = Bool.random()
        let percentage = (Double.random(in: 1...10) * 100).rounded() / 100
        let price = (Double.random(in: 130...150) * 100).rounded() / 100

        return Signal(name: "Solana", price: price, percentage: percentage, isSignalUp: randomBool)
    }
}
