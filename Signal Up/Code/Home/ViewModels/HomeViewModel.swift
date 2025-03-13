//
//  HomeViewModel.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 10.03.25.
//

import Foundation
import ActivityKit

class HomeViewModel: ObservableObject {

    @Published var activities: [Activity<WidgetAttributes>] = []
    @Published var showAlertDown: Bool = false
    @Published var showAlertUp: Bool = false

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
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            self.createActivity()
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func createActivity() {
        if activities.count < 5 {
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
        } else {
            if let last = activities.last {
                endActivity(last) {
                    DispatchQueue.main.async {
                        self.createActivity()
                    }
                }
                DispatchQueue.main.async {
                    self.activities.removeLast()
                }
            }
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
}
