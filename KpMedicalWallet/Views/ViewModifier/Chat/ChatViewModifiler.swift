//
//  ChatViewModifiler.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/26/24.
//

import SwiftUI

struct ChatInputFiledLeftButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20))
            .foregroundColor(.gray)
            .padding(.leading)
    }
}
struct ChatInputSendingButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 30))
            .foregroundColor(.blue)
    }
}
struct ChatInputHstackModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.leading)
            .frame(height: 40)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
            .padding(.trailing, 10)
    }
}
