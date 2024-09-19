//
//  ReservationFinalView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/19/24.
//

import SwiftUI

struct ReservationFinalView: View {
    @EnvironmentObject var viewModel:HospitalReservationModel
    @State var test: Bool = false
    var body: some View {
        
        VStack{
            if viewModel.isRequestFalse{
                ErrorView()
            }
            if viewModel.isRequestFinish{
                HStack{
                    Text("예약이 완료되었습니다.")
                        .font(.title)
                        .bold()
                        .padding(.leading)
                    Spacer()
                }
                HStack{
                    VStack(alignment: .leading){
                        Text("10분 전까지 도착해 주세요!")
                            .bold()
                            .padding(.horizontal,30)
                            .padding([.vertical])
                        Text("예약 시간에 늦으면 예약이 취소되며")
                            .padding(.horizontal,30)
                            .font(.system(size: 14))
                        Text("다음예약에 불이익이 있을 수 있습니다.")
                            .font(.system(size: 14))
                            .padding(.horizontal,30)
                            .padding(.bottom)
                        
                    }
                    Image(systemName: "clock.fill")
                        .foregroundColor(Color("AccentColor"))
                        .font(.system(size: 30))
                        .imageScale(.large)
                        .padding()
                }
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.bottom)
                .padding(.top)
                
                HStack{
                    Text("병원")
                        .modifier(ReservationSuccessViewGuaidText())
                    Spacer()
                    Text(viewModel.reservationData.hospital_name)
                        .modifier(ReservationSuccessViewInfoText())
                }
                .padding(.bottom,10)
                HStack{
                    Text("의사명")
                        .modifier(ReservationSuccessViewGuaidText())
                    Spacer()
                    Text(viewModel.reservationData.doc_name)
                        .modifier(ReservationSuccessViewInfoText())
                }
                .padding(.bottom,10)
                HStack{
                    Text("환자명")
                        .modifier(ReservationSuccessViewGuaidText())
                    Spacer()
                    Text(viewModel.appManager!.name)
                        .modifier(ReservationSuccessViewInfoText())
                }
                .padding(.bottom,10)
                HStack{
                    Text("방문목적")
                        .modifier(ReservationSuccessViewGuaidText())
                    Spacer()
                    Text(viewModel.reservationData.symptom)
                        .modifier(ReservationSuccessViewInfoText())
                }
                .padding(.bottom,10)
                HStack{
                    Text("일정")
                        .modifier(ReservationSuccessViewGuaidText())
                    Spacer()
                    Text("\(viewModel.reservationData.date)-\(viewModel.reservationData.time)")
                        .modifier(ReservationSuccessViewInfoText())
                }
                .padding(.bottom,10)
                Spacer()
                Button{
                    viewModel.goToMyReservationView()
                } label: {
                    Text(PlistManager.shared.string(forKey: "ok"))
                        .modifier(ReservationButtonStyleModifier(State: $viewModel.isRequestFinish))
                }
                .padding(.bottom)
                .padding(.horizontal)
            }
            else{
                Spacer()
                Text("예약 요청을 진행중입니다.")
                ProgressView()
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear{
            viewModel.requestSaveReservation()
        }
    }
}

struct ReservationFinalView_Previews: PreviewProvider {
    static var previews: some View {
        
        @StateObject var env = HospitalReservationModel()
        ReservationFinalView()
            
            .environmentObject(env)
    }
}
