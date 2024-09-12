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
struct CheckIDFiledButton: ViewModifier{
    @Binding var active: Bool
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .foregroundColor(.white)
            .padding(.horizontal,10)
            .padding(.vertical)
            .background(active ? Color("AccentColor") : Color.gray.opacity(0.6) )
            .cornerRadius(10)
            
    }
}

struct SinupIDFildModifier: ViewModifier {
    @Binding var check: Bool
    func body(content: Content) -> some View {
        content
            .textCase(.lowercase)
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(check ? Color.clear : Color.red, lineWidth: 1)
            )
    }
}
struct SinupPASSWORDFildModifier: ViewModifier {
    @Binding var check: Bool
    func body(content: Content) -> some View {
        content
            .textCase(.lowercase)
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(check ? Color.clear : Color.red, lineWidth: 1)
            )
    }
}

struct SignupErrorMessageText: ViewModifier{
    @Binding var check: Bool
    func body(content: Content) -> some View {
        content
            .font(.system(size: 13))
            .foregroundStyle(check ? Color("AccentColor") : Color.red)
    }
}
