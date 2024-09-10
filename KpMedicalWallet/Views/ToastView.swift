//
//  ToastView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var toast: normal_Toast?
    @State private var workItem: DispatchWorkItem?
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainToastView()
                        .offset(y: -30)
                }.animation(.spring(), value: toast)
            ).onChange(of: toast) {
                showToast()
            }
    }
    @ViewBuilder func mainToastView() -> some View {
        if let toast = toast {
            VStack {
                Spacer()
                normalToast(
                    message: toast.message) {
                        dismissToast()
                    }
            }
            .transition(.move(edge: .bottom))
        }
    }
    private func showToast() {
        guard let toast = toast else { return }
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        if toast.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissToast()
            }
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }
    
    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        
        workItem?.cancel()
        workItem = nil
    }
}


struct normalToast: View {
    var message: String
    var onCancelTapped: (() -> Void)
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(message)
                    .font(.system(size: 13))
                    .bold()
                    .padding()
                    .foregroundStyle(Color.white)
                    .background(Color.black.opacity(0.9))
                    .cornerRadius(20)
            }
        }
    }
}

extension View {
    func normalToastView(toast: Binding<normal_Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
