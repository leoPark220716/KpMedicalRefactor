//
//  TextFildModifier.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import SwiftUI

struct IDFildModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textCase(.lowercase)
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
    }
}
struct LoginButton: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("AccentColor"))
            .cornerRadius(10)
    }
}
struct LoginSubText: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .foregroundStyle(Color.blue)
    }
}

