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
    
    @State private var blurView1 = UIVisualEffectView()
    @State private var blurView2 = UIVisualEffectView()
    
    init(appState: AppState) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(appState: appState))
    }
    
    var body: some View {
        ZStack {
            Color("BG").ignoresSafeArea()
            BackgroundCircles()
            MainContentView()
        }
        .padding()
        .onChange(of: viewModel.activities.first?.id) { _ in updateBlurEffect() }
        .onChange(of: appState.id) { _ in viewModel.toggleAlert() }
        .onChange(of: appState.isSignalUp) { _ in viewModel.toggleAlert() }
        .floatingBottomSheet(isPresented: $viewModel.showAlertDown) { SignalSheetView(isUp: false) }
        .floatingBottomSheet(isPresented: $viewModel.showAlertUp) { SignalSheetView(isUp: true) }
        .onAppear {
            DispatchQueue.main.async {
                viewModel.startTimer()
            }
        }
        .onDisappear {
            DispatchQueue.main.async {
                viewModel.stopTimer()
            }
        }
    }
    
    @ViewBuilder
    private func MainContentView() -> some View {
        VStack {
            VStack {
                if viewModel.currentActivity == nil {} else {
                    TokenDetailsView()
                }
            }
            .background {
                GlassMorphicCard(blurView: $blurView1)
                    .frame(height: viewModel.currentContentViewHeight, alignment: .center)
                    .frame(maxWidth: .infinity)
            }
            .frame(height: viewModel.currentContentViewHeight, alignment: .center)
            .onChange(of: viewModel.currentActivity?.id) { _ in
                viewModel.updatePrice()
                withAnimation {
                    viewModel.currentContentViewHeight = 100
                }
            }
            
            ActiveSignalListView()
                .background {
                    GlassMorphicCard(blurView: $blurView2)
                        .frame(height: viewModel.activeSignalListViewHeight, alignment: .center)
                }
                .frame(height: viewModel.activeSignalListViewHeight, alignment: .center)
                .onChange(of: viewModel.activities.first?.id) { _ in
                    if viewModel.activities.count > 1 && viewModel.activeSignalListViewHeight < 300 {
                        withAnimation {
                            viewModel.activeSignalListViewHeight += 50
                        }
                    }
                }
            Spacer()
        }
    }
    
    @ViewBuilder
    private func BackgroundCircles() -> some View {
        CircleView(gradientColors: [.color1, .color2], size: 300, offset: CGSize(width: 100, height: -300))
        CircleView(gradientColors: [.color3, .color4], size: 160, offset: CGSize(width: -150, height: 60))
        CircleView(gradientColors: [.color5, .color6], size: 200, offset: CGSize(width: 150, height: 100))
        CircleView(gradientColors: [.color7, .color8], size: 300, offset: CGSize(width: -40, height: 400))
        CircleView(gradientColors: [.color9, .color10], size: 80, offset: CGSize(width: 50, height: -90))
    }
    
    @ViewBuilder
    private func ActiveSignalListView() -> some View {
        VStack(spacing: 0) {
            Text("Browse and Monitor All Active Signal States and Their Details")
                .padding()
                .foregroundColor(.black)
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 80)
            
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
                                    .stroke(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                            })
                        
                    } else {
                        ForEach(viewModel.activities, id: \.id) { activity in
                            SignalActivityRow(activity)
                                .transition(.slide)
                                .onAppear {
                                    if let firstActivity = viewModel.activities.first {
                                        viewModel.currentActivity = firstActivity
                                    }
                                }
                        }
                    }
                }
                .animation(.spring(response: 0.8, dampingFraction: 0.8), value: UUID())
            }
            .scrollDisabled(true)
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
            .padding(10)
            .background(activity.attributes.isSignalUp ? Color.customGreen.gradient : Color.customRed.gradient)
            .foregroundColor(.black)
            .cornerRadius(10)
            .font(.system(size: 16))
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
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
                tokenName: "Token Price",
                tokenNamePlaceholder: signal.name,
                tokenIcon: "solana-logo",
                currentPrice: "\(signal.price)",
                finalPrice: String(format: "%.2f", roundedPrice),
                percentage: isUp ? "+\(signal.percentage)" : "-\(signal.percentage)"
            )
        )
        .presentationDetents([.height(isUp ? 360 : 380)])
    }
    
    @ViewBuilder
    private func GlassMorphicCard(blurView: Binding<UIVisualEffectView>) -> some View {
        ZStack {
            CustomBlurView(effect: .systemUltraThinMaterial) { view in
                blurView.wrappedValue = view
                if viewModel.defaultBlurRadius == 0 { viewModel.defaultBlurRadius = view.gaussianBlurRadius }
                if viewModel.defaultSaturationAmount == 0 { viewModel.defaultSaturationAmount = view.saturationAmount}
            }
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.linearGradient(colors: [.white.opacity(0.25), .white.opacity(0.25)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .blur(radius: 5)
            
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .stroke(.linearGradient(colors: [.white.opacity(0.6), .clear, .purple.opacity(0.2), .purple.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
        }
        .shadow(color: .black.opacity(0.15), radius: 5, x: -10, y: 10)
        .shadow(color: .black.opacity(0.15), radius: 5, x: 10, y: -10)
    }
    
    @ViewBuilder
    private func TokenDetailsView() -> some View {
        VStack(alignment: .leading) {
            
            if let currentActivity = viewModel.currentActivity?.attributes {
                TokenDetailRow(tokenName: currentActivity.name, imageString: "solana-logo")
                PriceDetailsRow()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .cornerRadius(10)
    }
    
    @ViewBuilder
    private func TokenDetailRow(tokenName: String, imageString: String) -> some View {
        HStack {
            Text(tokenName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            
            Spacer()
            
            Text("Token Price")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            Image(imageString)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
        }
    }
    
    @ViewBuilder
    private func PriceDetailsRow() -> some View {
        HStack(spacing: 4) {
            HStack(spacing: 0) {
                Text("$")
                Text(String(viewModel.currentPrice))
                    .contentTransition(.numericText())
                    .animation(.easeInOut(duration: 0.3), value: viewModel.currentPrice)
            }
            .font(.system(size: 24, weight: .semibold))
            .foregroundColor(.black)
            Spacer()
            Image(systemName: "arrowshape.right.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.black)
            Spacer()
            HStack(spacing: 0) {
                Text("$")
                Text(String(viewModel.currentFinalPrice))
                    .contentTransition(.numericText())
                    .animation(.easeInOut(duration: 0.3), value: viewModel.currentFinalPrice)
            }
            .font(.system(size: 24, weight: .semibold))
            .foregroundColor(.black)
            
            Text(String(viewModel.currentPercentagePrice) + "%")
                .font(.system(size: 12, weight: .bold))
                .padding(6)
                .background(Color.black)
                .clipShape(Capsule())
                .foregroundColor(.white)
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 0.3), value: viewModel.currentPercentagePrice)
        }
    }
    
    private func updateBlurEffect() {
        let blurRadius = viewModel.activities.isEmpty ? viewModel.defaultBlurRadius : 10
        let saturation = viewModel.activities.isEmpty ? viewModel.defaultSaturationAmount : 8
        blurView1.gaussianBlurRadius = blurRadius
        blurView1.saturationAmount = saturation
        blurView2.gaussianBlurRadius = blurRadius
        blurView2.saturationAmount = saturation
    }
}

#Preview {
    HomeView(appState: AppState(signalState: .upState, price: 100, percentage: 20, name: "Solana", isSignalUp: true))
        .environmentObject(AppState(signalState: .upState, price: 100, percentage: 20, name: "Solana", isSignalUp: true))
}
