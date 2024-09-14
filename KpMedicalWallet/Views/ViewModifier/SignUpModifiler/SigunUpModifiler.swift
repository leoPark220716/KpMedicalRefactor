//
//  SwiftUIView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/12/24.
//
import SwiftUI

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

struct SinupTextFildModifier: ViewModifier {
    @Binding var check: Bool
    @FocusState var focus: Bool
    func body(content: Content) -> some View {
        content
            .focused($focus)
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

struct SignupDobFieldModifier: ViewModifier{
    func body(content: Content) -> some View {
        content
            .disabled(true)
            .textCase(.lowercase)
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.clear, lineWidth: 1)
            )
    }
}

struct SginupGenderButtonModifier: ViewModifier{
    @Binding var gender: Gender?
    let male: Bool
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .foregroundStyle(
                male ? (gender == .male ? .white : Color.blue.opacity(0.6)) : (gender == .female ? .white : Color.pink.opacity(0.6))
            )
            .frame(width: 60, height: 50)
            .background(
                male ? (gender == .male ? Color.blue.opacity(0.6) : Color.clear) : (gender == .female ? Color.pink.opacity(0.6) : Color.clear)
            )
            .cornerRadius(10)
    }
}

struct SginupOtpFieldModifier: ViewModifier{
    @Binding var check: Bool
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .frame(width: 200, height: 30)
            .cornerRadius(10)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(!check ? Color.red : Color("AccentColor"), lineWidth: 2)
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
struct SignupTitldGuaidLine: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.footnote)
    }
}

struct SignupOtpGuaidLine: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.title)
    }
}

struct SignupOtpGuaidLineNumber: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
    }
}
