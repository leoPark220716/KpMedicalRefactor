//
//  ReservationDoctorChooseView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/19/24.
//

import SwiftUI

struct ReservationDoctorChooseView: View {
    @EnvironmentObject var viewModel: HospitalReservationModel
    var body: some View {
        VStack{
            ScrollView{
                if !viewModel.DoctorProfileInChooseView.isEmpty{
                    ForEach(viewModel.DoctorProfileInChooseView.indices,id: \.self){ index in
                        Button{
                            let setScedule = viewModel.setReservationDoctor(index: index)
                            if setScedule{
                                viewModel.DoctorViewGoToNextView()
                            }
                        } label: {
                            DoctorListItemViewForReservation(DoctorProfile: viewModel.DoctorProfileInChooseView[index])
                        }
                        Divider()
                            .modifier(ReservationDividerStyleModifier())
                    }
                }
            }
        }
        .onAppear{
            viewModel.setReservationDoctorList()
        }
    }
}

struct ReservationDoctorChooseView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var env = HospitalReservationModel()
        ReservationDoctorChooseView()
            .environmentObject(env)
    }
}
