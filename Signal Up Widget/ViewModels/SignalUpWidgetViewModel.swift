//
//  SignalUpWidgetViewModel.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 20.03.25.
//

import Foundation
import WidgetKit
import SwiftUICore

class SignalUpWidgetViewModel: ObservableObject {
    let context: ActivityViewContext<WidgetAttributes>
    let urlService = WidgetURLService()
    
    init(context: ActivityViewContext<WidgetAttributes>) {
        self.context = context
    }
    
    func generateURL() -> URL? {
        return urlService.generateURL(from: context.attributes)
    }
    
    func formattedPrice() -> String {
        return "$\(String(context.attributes.price))"
    }
    
    func formattedPercentage() -> String {
        return "\(context.attributes.isSignalUp ? "+" : "-") \(String(context.attributes.percentage))%"
    }
    
    func signalColor() -> Color {
        return context.attributes.isSignalUp ? .customGreen : .customRed
    }
}
