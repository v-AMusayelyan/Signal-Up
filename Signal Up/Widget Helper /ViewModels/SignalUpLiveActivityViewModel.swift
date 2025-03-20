//
//  SignalUpLiveActivityViewModel.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 10.03.25.
//

import Foundation

class SignalUpLiveActivityViewModel: ObservableObject {
    @Published var context: WidgetAttributes
    private let urlService = WidgetURLService()
    
    init(context: WidgetAttributes = SignalUpLiveActivityViewModel.defaultContext()) {
        self.context = context
    }
    
    func generateURL() -> URL? {
        return urlService.generateURL(from: context)
    }
    
    static func defaultContext() -> WidgetAttributes {
        return WidgetAttributes(id: UUID(), price: 100, percentage: 20, name: "Solana", isSignalUp: false)
    }
}
