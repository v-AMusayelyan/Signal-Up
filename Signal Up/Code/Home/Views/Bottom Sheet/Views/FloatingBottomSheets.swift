//
//  FloatingBottomSheets.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 04.03.25.
//

import SwiftUI

// MARK: - Floating Bottom Sheets
struct FloatingBottomSheets: View {
    @State private var showAlert: AlertType?
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 10) {
                    FloatingBottomSheetsCustomButton(title: "Up", backgroundColor: .green) {
                        showAlert = .up
                    }
                    FloatingBottomSheetsCustomButton(title: "Down", backgroundColor: .red) {
                        showAlert = .down
                    }
                }
                .padding(10)
                .background(.gray.gradient.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .black.opacity(0.1), radius: 15)
                .padding(.bottom, 200)
            }
            .navigationTitle("Floating Bottom Sheets")
        }
        .floatingBottomSheet(isPresented: Binding(
            get: { showAlert != nil },
            set: { if !$0 { showAlert = nil } }
        )) {
            if let alertType = showAlert {
                let appState = alertType.appState
                
                SheetView(
                    alertConfig: FloatingBottomSheetAlertConfig(
                        title: alertType == .up ? "Signal Up" : "Signal Down",
                        description: "This signal indicates that the \(appState.name) mark will \(alertType == .up ? "increase" : "decrease") by \(appState.percentage)%."
                    ),
                    imageConfig: FloatingBottomSheetComponentConfig(
                        content: alertType == .up ? "arrowshape.up.fill" : "arrowshape.down.fill",
                        tint: alertType == .up ? .customGreen : .customRed,
                        foreground: .white
                    ),
                    buttonConfig: FloatingBottomSheetComponentConfig(
                        content: "Show Details",
                        tint: alertType == .up ? .customGreen : .customRed,
                        foreground: .black
                    ),
                    tokenDetailsConfig: FloatingBottomSheetTokenDetailsConfig(
                        isSignUp: alertType == .up,
                        tokenName: "Token Price",
                        tokenNamePlaceholder: appState.name,
                        tokenIcon: "solana-logo",
                        currentPrice: "\(appState.price)",
                        finalPrice: String(format: "%.2f", (appState.price + (appState.isSignalUp ? 1 : -1) * (appState.price * appState.percentage / 100))),
                        percentage: "\(alertType == .up ? "+" : "-")\(appState.percentage)"
                    )
                )
                .presentationDetents([.height(380)])
            }
        }
    }
}

// MARK: - Alert Type
private enum AlertType {
    case up, down
    
    var appState: AppState {
        let isUp = self == .up
        let percentage: Double = 10
        let price: Double = 100
        
        return AppState(
            signalState: isUp ? .upState : .downState,
            price: price,
            percentage: percentage,
            name: "Solana",
            isSignalUp: isUp
        )
    }
}

// MARK: - Custom Button
struct FloatingBottomSheetsCustomButton: View {
    var title: String
    var backgroundColor: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(10)
                .background(backgroundColor.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .tint(.white)
                .fontWeight(.semibold)
        }
    }
}

// MARK: - Preview
#Preview {
    FloatingBottomSheets()
}
