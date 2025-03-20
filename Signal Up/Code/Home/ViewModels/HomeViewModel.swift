//
//  HomeViewModel.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 10.03.25.
//

import Foundation
import ActivityKit
import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var activities: [Activity<WidgetAttributes>] = []
    @Published var showAlertDown: Bool = false
    @Published var showAlertUp: Bool = false
    @Published var currentActivity: Activity<WidgetAttributes>?
    
    @Published var currentPrice: String = ""
    @Published var currentFinalPrice: String = ""
    @Published var currentPercentagePrice: String = ""
    
    @Published var defaultBlurRadius: CGFloat = 0
    @Published var defaultSaturationAmount: CGFloat = 0
    @Published var currentContentViewHeight: Double = 0
    @Published var activeSignalListViewHeight: Double = 140
    
    private var timer: Timer?
    var appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    func toggleAlert() {
        showAlertDown = !appState.isSignalUp
        showAlertUp = appState.isSignalUp
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.createActivity()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func createActivity() {
        guard activities.count < 5 else {
            if let last = activities.last {
                endActivity(last) {
                    self.createActivity()
                }
                activities.removeLast()
            }
            return
        }
        
        let signal = SignalModel.generateRandomSignal()
        let attributes = WidgetAttributes(price: signal.price, percentage: signal.percentage, name: signal.name, isSignalUp: signal.isSignalUp)
        let content = WidgetAttributes.Content(tokenName: signal.name)
        
        do {
            let activity = try Activity<WidgetAttributes>.request(
                attributes: attributes,
                content: ActivityContent(state: content, staleDate: nil),
                pushType: .token
            )
            
            DispatchQueue.main.async {
                self.activities.insert(activity, at: 0)
            }
        } catch {
            print("Error requesting activity: \(error.localizedDescription)")
        }
    }
    
    func endActivity(_ activity: Activity<WidgetAttributes>, completion: @escaping () -> Void) {
        Task {
            await activity.end(activity.content)
            if let index = activities.firstIndex(where: { $0.id == activity.id }) {
                activities.remove(at: index)
            }
            completion()
        }
    }
    
    func updatePrice() {
        let placeholderPrice = "000.00"
        let finalPrice = "999.99"
        let percentagePrice = "9.99"
        
        withAnimation {
            self.currentPrice = placeholderPrice
            self.currentFinalPrice = placeholderPrice
            self.currentPercentagePrice = "0.00"
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                self.currentPrice = finalPrice
                self.currentFinalPrice = finalPrice
                self.currentPercentagePrice = percentagePrice
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            withAnimation {
                var kkk = 0.0
                
                if let ggg = self.currentActivity?.attributes {
                    
                    if ggg.isSignalUp {
                        kkk = ggg.price + ggg.price * ggg.percentage / 100
                    } else {
                        kkk = ggg.price - ggg.price * ggg.percentage / 100
                    }
                }
                self.currentPrice = String(self.currentActivity?.attributes.price ?? 0)
                self.currentFinalPrice = String(format: "%.2f", kkk)
                self.currentPercentagePrice = String(self.currentActivity?.attributes.percentage ?? 0)
            }
        }
    }
}
