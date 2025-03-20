//
//  SheetView.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 04.03.25.
//

import SwiftUI

struct SheetView: View {
    @StateObject private var viewModel: SheetViewModel
    
    @State var alertConfig: FloatingBottomSheetAlertConfig
    @State var imageConfig: FloatingBottomSheetComponentConfig
    @State var buttonConfig: FloatingBottomSheetComponentConfig
    @State var tokenDetailsConfig: FloatingBottomSheetTokenDetailsConfig
    
    @Environment(\.dismiss) private var dismiss
    
    init(alertConfig: FloatingBottomSheetAlertConfig,
         imageConfig: FloatingBottomSheetComponentConfig,
         buttonConfig: FloatingBottomSheetComponentConfig,
         tokenDetailsConfig: FloatingBottomSheetTokenDetailsConfig) {
        self._alertConfig = State(initialValue: alertConfig)
        self._imageConfig = State(initialValue: imageConfig)
        self._buttonConfig = State(initialValue: buttonConfig)
        self._tokenDetailsConfig = State(initialValue: tokenDetailsConfig)
        self._viewModel = StateObject(wrappedValue: SheetViewModel(tokenDetailsConfig: tokenDetailsConfig))
    }
    
    var body: some View {
        VStack(spacing: 15) {
            // MARK: - Icon
            iconView()
            
            // MARK: - Title & Description
            titleAndDescriptionView()
            
            // MARK: - Token Details
            tokenDetailsView()
            
            // MARK: - Dismiss Button
            dismissButtonView()
        }
        .padding([.horizontal, .bottom], 15)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.background)
                .padding(.top, 30)
        }
        .shadow(color: .black.opacity(0.12), radius: 8)
        .padding(.horizontal, 15)
        .onAppear {
            viewModel.startPriceUpdate()
        }
        .onDisappear {
            viewModel.stopPriceUpdate()
        }
    }
    
    // MARK: - Icon View
    private func iconView() -> some View {
        ZStack {
            Capsule()
                .foregroundStyle(imageConfig.tint.opacity(0.5))
                .frame(width: 75, height: 75)
            
            Image(systemName: imageConfig.content)
                .font(.title)
                .foregroundStyle(imageConfig.foreground)
                .frame(width: 65, height: 65)
                .background(imageConfig.tint.gradient, in: .capsule(style: .circular))
        }
    }
    
    // MARK: - Title & Description View
    private func titleAndDescriptionView() -> some View {
        VStack {
            Text(alertConfig.title)
                .font(.system(size: 26, weight: .bold))
            
            Text(alertConfig.description)
                .font(.callout)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundStyle(.gray)
        }
    }
    
    // MARK: - Token Details View
    private func tokenDetailsView() -> some View {
        VStack(alignment: .leading) {
            tokenDetailRow()
            priceDetailsRow()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(tokenDetailsConfig.isSignUp ? Color.customGreen.gradient : Color.customRed.gradient)
        .cornerRadius(10)
    }
    
    private func tokenDetailRow() -> some View {
        HStack {
            Text(tokenDetailsConfig.tokenName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            Spacer()
            Text(tokenDetailsConfig.tokenNamePlaceholder)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
            Image(tokenDetailsConfig.tokenIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
        }
    }
    
    private func priceDetailsRow() -> some View {
        HStack(spacing: 4) {
            HStack(spacing: 0) {
                Text("$")
                Text(viewModel.currentPrice)
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
                Text(viewModel.finalPrice)
                    .contentTransition(.numericText())
                    .animation(.easeInOut(duration: 0.3), value: viewModel.finalPrice)
            }
            .font(.system(size: 24, weight: .semibold))
            .foregroundColor(.black)
            
            Text(viewModel.percentagePrice + "%")
                .font(.system(size: 12, weight: .bold))
                .padding(6)
                .background(Color.black)
                .clipShape(Capsule())
                .foregroundColor(.white)
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 0.3), value: viewModel.percentagePrice)
        }
    }
    
    // MARK: - Dismiss Button View
    private func dismissButtonView() -> some View {
        Button {
            dismiss()
        } label: {
            Text(buttonConfig.content)
                .fontWeight(.semibold)
                .foregroundStyle(buttonConfig.foreground)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(buttonConfig.tint.gradient, in: .rect(cornerRadius: 10))
        }
    }
}

// MARK: - Preview
#Preview {
    FloatingBottomSheets()
}
