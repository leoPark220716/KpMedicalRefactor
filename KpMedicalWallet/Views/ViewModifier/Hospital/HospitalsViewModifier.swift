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
struct HospitalDetailPickerText: ViewModifier{
    @Binding var selection: HospitalDetailContent.Selection
    let set: HospitalDetailContent.Selection
    func body(content: Content) -> some View {
        content
            .font(.system(size: 15))
            .frame(maxWidth: .infinity,alignment: .center)
            .foregroundColor(selection == set ? .black : .gray)
            .padding(.vertical,4)
    }
}
struct HospitalDetailPickerUnderBar: ViewModifier{
    @Binding var selection: HospitalDetailContent.Selection
    let set: HospitalDetailContent.Selection
    func body(content: Content) -> some View {
        content
            .frame(height: 2) // 전체 너비의 40%로 설정
            .foregroundColor(selection == set ? Color("AccentColor").opacity(0.4) : .clear)
            .cornerRadius(10)
            .padding(.horizontal)
    }
}
struct HospitalDetailScheduleModify: ViewModifier{
    let schedule: String
    let width: Double
    let aligment: Alignment
    func body(content: Content) -> some View {
        content
            .font(.system(size: 13))
            .foregroundColor(schedule == "일요일" ? .red : .black)
            .frame(width: width, alignment: aligment)
    }
}
struct HospitalDetailEmptyScheduleModify: ViewModifier{
    let schedule: String
    let width: Double
    let aligment: Alignment
    func body(content: Content) -> some View {
        content
            .font(.system(size: 13))
            .foregroundColor(schedule == "일요일" ? .red : .black)
            .frame(width: width, alignment: aligment)
    }
}
struct HospitalDetailButtonModify: ViewModifier{
    let back: Color
    let fore: Color
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.system(size: 14))
            .frame(maxWidth: .infinity)
            .foregroundStyle(fore)
            .background(back)
            .cornerRadius(5)
            .bold()
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.blue.opacity(0.5), lineWidth: 1)
            )
    }
}
struct HospitalDetailDoctorImageModify: ViewModifier{
    func body(content: Content) -> some View {
        content
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .shadow(radius: 10, x: 5, y: 5)
            .padding()
    }
}
struct HospitalDetailDoctorProfileText: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .bold()
    }
}
