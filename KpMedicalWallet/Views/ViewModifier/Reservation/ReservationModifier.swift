//
//  ReservationModifier.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/21/24.
//

import SwiftUI

struct ReservationListTextModifier: ViewModifier {
    let color: Color
    func body(content: Content) -> some View {
        content
            .foregroundStyle(color)
            .font(.subheadline)
            .bold()
    }
}
struct ReservationListTimeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .bold()
            .font(.system(size: 13))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color("AccentColor"))
            .cornerRadius(10)
            .foregroundColor(.white)
    }
}
struct ReservationListHospitalNameModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color.black)
            .font(.headline)
            .bold()
    }
}
    
