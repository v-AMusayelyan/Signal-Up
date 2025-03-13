//
//  LiveActivityView.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 28.02.25.
//

import SwiftUI
import Foundation
import WidgetKit

struct SignalUpLiveActivityView: View {
    @StateObject private var viewModel: SignalUpLiveActivityViewModel

    init(context: WidgetAttributes = SignalUpLiveActivityViewModel.defaultContext()) {
        _viewModel = StateObject(wrappedValue: SignalUpLiveActivityViewModel(context: context))
    }

    var body: some View {
        VStack {
            HStack {
                leadingHeaderView()
                Spacer()
                trailingHeaderView()
            }
            centerContentView()
            HStack(spacing: 10) {
                buyButton()
                sellButton()
            }
        }
        .padding()
        .background(.black)
    }

    // MARK: - Header Views
    private func leadingHeaderView() -> some View {
        HStack(spacing: 6) {
            Image(systemName: "apple.logo")
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
                .foregroundColor(.white)

            Text("Signal Up")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 10)
    }

    private func trailingHeaderView() -> some View {
        HStack(spacing: 6) {
            Text("Open App")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)

            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .frame(width: 8, height: 8)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 10)
    }

    // MARK: - Center Content View
    private func centerContentView() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 2) {
                Image("solana-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)

                Text(viewModel.context.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }

            HStack(spacing: 4) {
                Text("$\(String(viewModel.context.price))")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)

                Text(" \(viewModel.context.isSignalUp ? "+" : "-") \(String(viewModel.context.percentage))%")
                    .font(.system(size: 12, weight: .bold))
                    .padding(6)
                    .background(viewModel.context.isSignalUp ? .customGreen : .customRed)
                    .clipShape(Capsule())
                    .foregroundColor(.black)
            }
        }
    }

    // MARK: - Action Buttons
    private func buyButton() -> some View {
        actionButton(title: "Signal Up", color: .customGreen, isSignalUp: viewModel.context.isSignalUp)
    }

    private func sellButton() -> some View {
        actionButton(title: "Signal Down", color: .customRed, isSignalUp: !viewModel.context.isSignalUp)
    }

    private func actionButton(title: String, color: Color, isSignalUp: Bool) -> some View {
        if let generatedURL = viewModel.generateURL() {
            return AnyView(
                Link(destination: generatedURL) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(isSignalUp ? color : .gray.opacity(0.2))
                        .clipShape(Capsule())
                        .foregroundColor(isSignalUp ? .black.opacity(0.8) : color)
                }
            )
        } else {
            return AnyView(Text("Invalid URL").foregroundColor(.white))
        }
    }
}

#Preview {
    SignalUpLiveActivityView()
}
