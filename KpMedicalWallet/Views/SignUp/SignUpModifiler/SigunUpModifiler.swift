//
//  SwiftUIView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/12/24.
//
import SwiftUI

struct ActiveUnActiveButton: ViewModifier{
    @Binding var active: Bool
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(active ? Color("AccentColor") : Color.gray.opacity(0.6) )
            .cornerRadius(10)
            
    }
}
struct CheckboxToggleStyle: ToggleStyle {
    @Environment(\.isEnabled) var isEnabled
    let isTitle: Bool
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                configuration.label
                    .foregroundColor(.primary)
                    .font(isTitle ? .headline : .system(size: 15))
                    .foregroundStyle(Color.black)
                    .bold(isTitle)
                Spacer() // 여백 추가
            }
        })
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
    }
}
