//
//  ReservationDepartmentView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/19/24.
//

import SwiftUI

struct ReservationDepartmentView: View {
    @EnvironmentObject var viewModel:HospitalReservationModel
    @State var State: Bool = false
    var body: some View {
        VStack{
            ForEach(viewModel.hospitalDepartments, id: \.self){ id in
                if let department = Department(rawValue: id){
                    Button{
                        viewModel.reservationData.department_id = id
                        State = true
                    } label: {
                        DepartmentView(name: department.name, isSelected: viewModel.reservationData.department_id == id)
                    }
                }
            }
            Spacer()
            HStack{
                Button{
                    viewModel.goToChooseDoctorView()
                }label: {
                    Text("의료진")
                        .modifier(ReservationButtonStyleModifier(State: $State))
                    
                }
                .disabled(viewModel.reservationData.department_id == 9999999)
                Button{
                    viewModel.goToChooseDateView()
                }label: {
                    Text("진료일")
                        .modifier(ReservationButtonStyleModifier(State: $State))
                }
                .disabled(viewModel.reservationData.department_id == 9999999)
            }
            .padding([.horizontal,.bottom])
        }
        .padding(.top)
        .navigationTitle("진료과를 선택해주세요")
    }
}

struct ReservationDepartmentView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var env = HospitalReservationModel()
        ReservationDepartmentView()
            .environmentObject(env)
    }
}
struct DepartmentView: View {
    let name: String
    var isSelected: Bool
    
    var body: some View {
        HStack {
            Text(name)
                .bold()
                .padding(.leading)
                .padding(.vertical)
                .foregroundStyle(isSelected ? Color.blue : Color.black)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(isSelected ? Color.blue.opacity(0.8) : Color.gray.opacity(0.8), lineWidth: 1)
        )
        .background(Color.white)
        .padding(.vertical, 3)
        .padding(.horizontal)
    }
}
