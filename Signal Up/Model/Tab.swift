//
//  Tab.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 20.03.25.
//

import Foundation
import SwiftUI

// MARK: - Tab Enumeration

enum Tab: String, CaseIterable {
    case home = "photo.stack"
    case chart = "bubble.left.and.text.bubble.right"
    case history = "square.3.layers.3d"
    case discover = "bell.and.waves.left.and.right"
    case settings = "bell.and.waves.left.and.right2"
    
    // MARK: - Computed Property: Title
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .chart: return "Chart"
        case .history: return "History"
        case .discover: return "Discover"
        case .settings: return "Settings"
        }
    }
    
    // MARK: - Computed Property: Icon
    
    var icon: String {
        switch self {
        case .home: return "house"
        case .chart: return "chart.pie"
        case .history: return "clock"
        case .discover: return "safari"
        case .settings: return "gearshape"
        }
    }
    
    // MARK: - Computed Property: Filled Icon
    
    var filledIcon: String {
        switch self {
        case .home: return "house.fill"
        case .chart: return "chart.pie.fill"
        case .history: return "clock.fill"
        case .discover: return "safari.fill"
        case .settings: return "gearshape.fill"
        }
    }
}
