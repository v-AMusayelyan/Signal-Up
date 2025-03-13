//
//  HomeView.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 03.03.25.
//

import SwiftUI
import ActivityKit
import UserNotifications

struct HomeView: View {

    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: HomeViewModel
    @Environment(\.scenePhase) private var scenePhase

    @State var blurView1: UIVisualEffectView = .init()
    @State var blurView2: UIVisualEffectView = .init()
    @State var defaultBlurRadius: CGFloat = 0
    @State var defaultSaturationAmount: CGFloat = 0

    init(appState: AppState) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(appState: appState))
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color("BG")
                    .ignoresSafeArea()

                // Add circles in the background as before
                CircleView(gradientColors: [.color1, .color2], size: 300, offset: CGSize(width: -40, height: 400))
                CircleView(gradientColors: [.color3, .color4], size: 160, offset: CGSize(width: -150, height: 60))
                CircleView(gradientColors: [.color5, .color6], size: 200, offset: CGSize(width: 150, height: 100))
                CircleView(gradientColors: [.color7, .color8], size: 300, offset: CGSize(width: 100, height: -300))
                CircleView(gradientColors: [.color9, .color10], size: 80, offset: CGSize(width: 50, height: -90))

                VStack {
                    GlassMorphicCard(blurView: $blurView1)
                        .frame(height: 200, alignment: .center)

                    ActiveSignalListView()
                        .padding()
                        .background {
                            GlassMorphicCard(blurView: $blurView2)
                        }
                        .frame(height: 346, alignment: .center)
                    Spacer()
                }
            }
            .padding()
            .onChange(of: viewModel.activities.isEmpty) { _ in
                blurView1.gaussianBlurRadius = (!viewModel.activities.isEmpty ? 2 : defaultBlurRadius)
                blurView1.saturationAmount = (!viewModel.activities.isEmpty ? 2 : defaultSaturationAmount)

                blurView2.gaussianBlurRadius = (!viewModel.activities.isEmpty ? 2 : defaultBlurRadius)
                blurView2.saturationAmount = (!viewModel.activities.isEmpty ? 2 : defaultSaturationAmount)
            }
            .onChange(of: appState.id) { _ in
                viewModel.toggleAlert()
            }
            .onChange(of: appState.isSignalUp) { _ in
                viewModel.toggleAlert()
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    viewModel.startTimer()
                } else if newPhase == .background {
                    viewModel.stopTimer()
                }
            }
            .navigationTitle("Signal Up App")
        }
        .floatingBottomSheet(isPresented: $viewModel.showAlertDown) {
            SignalSheetView(isUp: false)
        }
        .floatingBottomSheet(isPresented: $viewModel.showAlertUp) {
            SignalSheetView(isUp: true)
        }
    }

    @ViewBuilder
    private func ActiveSignalListView() -> some View {
        VStack(spacing: 0) {
            Text("Browse and Monitor All Active Signal States and Their Details")
                .padding()
                .foregroundColor(.black)
                .font(.system(size: 16))
                .fontWeight(.semibold)


            ScrollView {
                VStack(spacing: 10) {
                    if viewModel.activities.isEmpty {
                        Text("No active signals")
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                            .frame(maxWidth: 200, alignment: .center)
                            .frame(height: 10)
                            .padding()

                            .overlay(content: {
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .stroke(
                                        .linearGradient(colors: [
                                            .white,
                                            .clear,
                                            .purple.opacity(0.5),
                                            .purple
                                        ], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2
                                    )
                            })

                    } else {
                        ForEach(viewModel.activities, id: \.id) { activity in
                            SignalActivityRow(activity)
                                .transition(.slide)
                        }
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: UUID())
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func SignalActivityRow(_ activity: Activity<WidgetAttributes>) -> some View {
        HStack(spacing: 0) {
            HStack(spacing: 10) {
                Text("Signal For \(activity.attributes.name)")
                Text("$\(String(activity.attributes.price))")
                Text("$\(String(activity.attributes.percentage))%")
                Image(systemName: activity.attributes.isSignalUp ? "arrowshape.up.fill" : "arrowshape.down.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .padding(10)
            .background(activity.attributes.isSignalUp ? Color.customGreen.gradient : Color.customRed.gradient)
            .foregroundColor(.black)
            .cornerRadius(10)
            .font(.system(size: 16))
            .fontWeight(.semibold)
        }
    }

    @ViewBuilder
    private func SignalSheetView(isUp: Bool) -> some View {
        let signal = viewModel.appState
        let calculatedPrice = isUp
        ? signal.price + (signal.price * signal.percentage / 100)
        : signal.price - (signal.price * signal.percentage / 100)
        let roundedPrice = (calculatedPrice * 100).rounded() / 100

        SheetView(
            alertConfig: FloatingBottomSheetAlertConfig(
                title: isUp ? "Signal Up" : "Signal Down",
                description: "This signal indicates that the \(signal.name) mark will \(isUp ? "increase" : "decrease") by \(signal.percentage)%."),
            imageConfig: FloatingBottomSheetComponentConfig(
                content: isUp ? "arrowshape.up.fill" : "arrowshape.down.fill",
                tint: isUp ? .customGreen : .customRed,
                foreground: .white),
            buttonConfig: FloatingBottomSheetComponentConfig(
                content: "Show Details",
                tint: isUp ? .customGreen : .customRed,
                foreground: .black),
            tokenDetailsConfig: FloatingBottomSheetTokenDetailsConfig(
                isSignUp: isUp,
                tokenName: "Token",
                tokenNameText: signal.name,
                tokenIcon: "solana-logo",
                currentPrice: "\(signal.price)",
                finalPrice: String(format: "%.2f", roundedPrice),
                percentage: isUp ? "+\(signal.percentage)" : "-\(signal.percentage)"
            )
        )
        .presentationDetents([.height(isUp ? 360 : 380)])
    }

    @ViewBuilder
    func GlassMorphicCard(blurView: Binding<UIVisualEffectView>) -> some View {
        ZStack {
            // Custom Blur View
            CustomBlurView(effect: .systemUltraThinMaterial) { view in
                blurView.wrappedValue = view
                if defaultBlurRadius == 0 { defaultBlurRadius = view.gaussianBlurRadius }
                if defaultSaturationAmount == 0 { defaultSaturationAmount = view.saturationAmount}
            }
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))

            // Overlay Shapes
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    .linearGradient(colors: [
                        .white.opacity(0.25),
                        .white.opacity(0.25)
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .blur(radius: 5)

            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .stroke(
                    .linearGradient(colors: [
                        .white.opacity(0.6),
                        .clear,
                        .purple.opacity(0.2),
                        .purple.opacity(0.5)
                    ], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2
                )
        }
        .shadow(color: .black.opacity(0.15), radius: 5, x: -10, y: 10)
        .shadow(color: .black.opacity(0.15), radius: 5, x: 10, y: -10)
    }
}

#Preview {
    HomeView(appState: AppState(signalState: .upState, price: 100, percentage: 20, name: "Solana", isSignalUp: true))
        .environmentObject(AppState(signalState: .upState, price: 100, percentage: 20, name: "Solana", isSignalUp: true))
}
