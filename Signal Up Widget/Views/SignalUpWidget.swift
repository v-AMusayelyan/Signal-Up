//
//  SignalUpWidget.swift
//  Signal Up WidgetExtension
//
//  Created by Aren Musayelyan on 03.03.25.
//

import Foundation
import SwiftUI
import WidgetKit

// MARK: - Widget
struct SignalUpWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WidgetAttributes.self) { context in
            SignalUpLiveActivityView(context: context.attributes)
        } dynamicIsland: { context in
            let viewModel = SignalUpWidgetViewModel(context: context)
            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    imageWithTextPair(imageName: "apple.logo", text: "Signal Up", fontSize: 12)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    expandedTrailingView()
                }
                DynamicIslandExpandedRegion(.center) {
                    expandedCenterView(viewModel: viewModel)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    expandedBottomView(viewModel: viewModel)
                }
            } compactLeading: {
                compactLeadingView(viewModel: viewModel)
            } compactTrailing: {
                compactTrailingView()
            } minimal: {
                AnyView(EmptyView())
            }
            .keylineTint(.cyan)
        }
    }
}

// MARK: - Views
func expandedBottomView(viewModel: SignalUpWidgetViewModel) -> some View {
    HStack {
        expandedButtonView(viewModel: viewModel, title: "Signal Up", color: .customGreen, isSignalUp: viewModel.context.attributes.isSignalUp)
        expandedButtonView(viewModel: viewModel, title: "Signal Down", color: .customRed, isSignalUp: !viewModel.context.attributes.isSignalUp)
    }
}

func expandedButtonView(viewModel: SignalUpWidgetViewModel, title: String, color: Color, isSignalUp: Bool) -> some View {
    if let generatedURL = viewModel.generateURL() {
        return AnyView(
            Link(destination: generatedURL) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .padding(7)
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

func expandedCenterView(viewModel: SignalUpWidgetViewModel) -> some View {
    VStack(spacing: 6) {
        HStack(spacing: 0) {
            Image("solana-logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)

            Text(viewModel.context.attributes.name)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding(.horizontal)

        HStack(spacing: 0) {
            Text(viewModel.formattedPrice())
                .font(.system(size: 26, weight: .semibold))
                .foregroundColor(.white)

            Text(viewModel.formattedPercentage())
                .font(.system(size: 10, weight: .semibold))
                .padding(4)
                .background(viewModel.signalColor())
                .clipShape(Capsule())
                .foregroundColor(.black)
        }
    }
}

func compactLeadingView(viewModel: SignalUpWidgetViewModel) -> some View {
    HStack(spacing: 4) {
        Image("solana-logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 24, height: 24)

        Text(viewModel.formattedPercentage())
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(viewModel.signalColor())
    }
    .padding(.leading, 6)
}

func compactTrailingView() -> some View {
    Image("chart")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 45, height: 20)
}

func expandedTrailingView() -> some View {
    HStack(spacing: 6) {
        Text("Open App")
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.white)

        Image(systemName: "chevron.right")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 8, height: 8)
            .foregroundColor(.white)
    }
    .frame(width: 80)
}

func imageWithTextPair(imageName: String, text: String, fontSize: CGFloat) -> some View {
    HStack(spacing: 6) {
        Image(systemName: imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 14, height: 14)
            .foregroundColor(.white)
        Text(text)
            .font(.system(size: fontSize, weight: .semibold))
            .foregroundColor(.white)
    }
    .frame(width: 80)
}
