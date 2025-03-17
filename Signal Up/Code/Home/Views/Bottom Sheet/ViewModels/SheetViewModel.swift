//
//  SheetViewModel.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 14.03.25.
//

import Foundation
import SwiftUI

class SheetViewModel: ObservableObject {
    @Published var currentPrice: String
    @Published var finalPrice: String
    @Published var percentagePrice: String
    
    private var timer: Timer?
    
    var tokenDetailsConfig: FloatingBottomSheetTokenDetailsConfig
    
    init(tokenDetailsConfig: FloatingBottomSheetTokenDetailsConfig) {
        self.tokenDetailsConfig = tokenDetailsConfig
        self.currentPrice = tokenDetailsConfig.currentPrice
        self.finalPrice = tokenDetailsConfig.finalPrice
        self.percentagePrice = tokenDetailsConfig.percentage
    }
    
    func startPriceUpdate() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            self.updatePrice()
        }
    }
    
    func stopPriceUpdate() {
        timer?.invalidate()
    }
    
    private func updatePrice() {
        withAnimation {
            self.currentPrice = "000.00"
            self.finalPrice = "000.00"
            self.percentagePrice = "+0.00"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                self.currentPrice = "999.99"
                self.finalPrice = "999.99"
                self.percentagePrice = "+9.99"
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation {
                self.currentPrice = self.tokenDetailsConfig.currentPrice
                self.finalPrice = self.tokenDetailsConfig.finalPrice
                self.percentagePrice = self.tokenDetailsConfig.percentage
            }
        }
    }
}
