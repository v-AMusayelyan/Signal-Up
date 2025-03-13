//
//  SheetView.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 04.03.25.
//

import SwiftUI

struct SheetView: View {

    @State var alertConfig: FloatingBottomSheetAlertConfig
    @State var imageConfig: FloatingBottomSheetComponentConfig
    @State var buttonConfig: FloatingBottomSheetComponentConfig
    @State var tokenDetailsConfig: FloatingBottomSheetTokenDetailsConfig

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 15) {

            // MARK: - Icon
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

            // MARK: - Title & Description
            Text(alertConfig.title)
                .font(.system(size: 26, weight: .bold))

            Text(alertConfig.description)
                .font(.callout)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundStyle(.gray)

            // MARK: - Token Details
            VStack(alignment: .leading) {
                HStack {
                    Text(tokenDetailsConfig.tokenName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    Spacer()
                    Text(tokenDetailsConfig.tokenNameText)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    Image(tokenDetailsConfig.tokenIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
                HStack(spacing: 4) {
                    Text("$" + tokenDetailsConfig.currentPrice)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "arrowshape.right.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)
                    Spacer()
                    Text("$" + tokenDetailsConfig.finalPrice)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.black)
                    Text(tokenDetailsConfig.percentage + "%")
                        .font(.system(size: 12, weight: .bold))
                        .padding(6)
                        .background(Color.black)
                        .clipShape(Capsule())
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .background(tokenDetailsConfig.isSignUp ? Color.customGreen.gradient : Color.customRed.gradient)
            .cornerRadius(10)

            // MARK: - Dismiss Button
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
        .padding([.horizontal, .bottom], 15)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.background)
                .padding(.top, 30)
        }
        .shadow(color: .black.opacity(0.12), radius: 8)
        .padding(.horizontal, 15)
    }
}

// MARK: - Preview
#Preview {
    FloatingBottomSheets()
}
