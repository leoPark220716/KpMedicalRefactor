//
//  HospitalsViewModifier.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/16/24.
//

import SwiftUI

struct HospitalsFindSearchFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 10)
            .frame(height: 40)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
            .padding(.horizontal)
    }
}
struct HospitalsFindSearchFieldGuaidLine: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundColor(.gray)
    }
}
struct HospitalsFindDepartmentText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 13))
            .padding(.leading,10)
            .padding(.vertical, 4)
            .foregroundColor(.blue)
    }
}
struct HospitalsFindDepartmentDirection: ViewModifier {
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(180))
            .font(.system(size: 10))
            .padding(.trailing,7)
    }
}
struct HospitalsFindDepartmentHStack: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            .padding(.trailing)
            .shadow(color: .gray.opacity(0.3), radius: 10, x: 10, y: 10)
    }
}
struct HospitalsFindPiker: ViewModifier {
    func body(content: Content) -> some View {
        content
            .pickerStyle(.segmented)
            .padding(.leading)
            .frame(width: 150)
    }
}
struct HospitalsDepartmentTexts: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.system(size: 13))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            .foregroundColor(.blue)
            .lineLimit(1)
    }
}
