//
//  CommonViewModifier.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/14/24.
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
struct ActiveButton: ViewModifier{
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

struct CardViewModifier: ViewModifier{
    let coler: Color
    func body(content: Content) -> some View {
        content
            .background(coler) // 배경색을 설정
            .cornerRadius(15) // 둥근 모서리 설정
            .shadow(radius: 10, x: 5, y: 5) // 그림자 설정
    }
}
