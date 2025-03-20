//
//  WidgetURLService.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 28.02.25.
//

import SwiftUI
import Foundation

class WidgetURLService {
    
    // MARK: - Extract Data from URL
    func extractData(from url: URL) -> [String: String]? {
        guard let urlComponents = URLComponents(string: url.absoluteString) else {
            return nil
        }
        
        var extractedData: [String: String] = [:]
        
        if let numberOfGroceyItems = urlComponents.queryItems?.first(where: { $0.name == "id" })?.value {
            extractedData["id"] = numberOfGroceyItems
        }
        
        if let price = urlComponents.queryItems?.first(where: { $0.name == "price" })?.value {
            extractedData["price"] = price
        }
        
        if let percentage = urlComponents.queryItems?.first(where: { $0.name == "percentage" })?.value {
            extractedData["percentage"] = percentage
        }
        
        if let name = urlComponents.queryItems?.first(where: { $0.name == "name" })?.value {
            extractedData["name"] = name
        }
        
        if let isSignalUp = urlComponents.queryItems?.first(where: { $0.name == "isSignalUp" })?.value {
            extractedData["isSignalUp"] = isSignalUp
        }
        
        return extractedData.isEmpty ? nil : extractedData
    }
    
    // MARK: - Generate URL from Attributes
    func generateURL(from attributes: WidgetAttributes) -> URL? {
        let queryParams = [
            "id": "\(attributes.id)",
            "price": "\(attributes.price)",
            "percentage": "\(attributes.percentage)",
            "name": attributes.name,
            "isSignalUp": "\(attributes.isSignalUp)"
        ]
        
        var urlComponents = URLComponents(string: "LiveActivities://")!
        urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        return urlComponents.url
    }
}
