//
//  FloatingSheetsHelper.swift
//  Signal Up
//
//  Created by Aren Musayelyan on 10.03.25.
//

import SwiftUI

extension View {
    @ViewBuilder
    func floatingBottomSheet<Content: View>(isPresented: Binding<Bool>, onDismiss: @escaping () -> () = {}, @ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .sheet(isPresented: isPresented, onDismiss: onDismiss) {
                if #available(iOS 16.4, *) {
                    content()
                        .presentationCornerRadius(0)
                        .presentationBackground(.clear)
                        .presentationDragIndicator(.hidden)
                        .background(SheetShadowRemover())
                }
            }
    }
}

fileprivate struct SheetShadowRemover: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let uiSheetView = view.viewBeforeWindow {
                for view in uiSheetView.subviews {
                    view.layer.shadowColor = UIColor.clear.cgColor
                }
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

fileprivate extension UIView {
    var viewBeforeWindow: UIView? {
        if let superview, superview is UIWindow {
            return self
        }
        return superview?.viewBeforeWindow
    }
}
