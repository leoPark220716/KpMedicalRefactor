//
//  departmentChooseSheetView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/16/24.
//

import SwiftUI

struct departmentsChooseSheetView: View {
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    @Binding var selectedDepartment: Department?
    @Environment(\.dismiss) private var dissmiss
    var onDepartmentSelect: ((Department) -> Void)?
    var body: some View {
        ScrollView{
            LazyVGrid(columns: columns){
                ForEach(Department.allCases, id: \.self){ department in
                    Button(action: {
                        self.selectedDepartment = department
                        onDepartmentSelect?(department)
                        dissmiss()
                    }){
                        Text(department.name)
                            .padding()
                            .font(department.name.count > 3 ? .system(size: 13) : .system(size: 14))
                            .frame(width: 100, height: 40)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.top, 20)
        }
    }
}
