//
//  ReservationDetailView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/21/24.
//

import SwiftUI

struct ReservationDetailView: View {
    @EnvironmentObject var appManager: NavigationRouter
    @StateObject var viewModel = HospitalReservationModel()
    let data: reservationArray
    var body: some View {
        GeometryReader { geo in
            VStack{
                ScrollView{
                    VStack{
                        HStack{
                            Text("예약정보")
                                .font(.title)
                                .bold()
                                .padding(.leading)
                            Spacer()
                        }
                        HStack{
                            Image(systemName: "checkmark")
                                .foregroundColor(Color .blue)
                                .font(.system(size: 20))
                                .bold()
                                .padding(.leading)
                            Text("확정된 예약입니다.")
                                .foregroundColor(Color .blue)
                                .bold()
                            Spacer()
                        }
                        .padding(.top,5)
                        
                        Divider()
                            .modifier(ReservationDividerStyleModifier())
                        
                        HStack{
                            Text("병원")
                                .font(.system(size: 15))
                                .foregroundStyle(Color.gray)
                                .bold()
                                .padding(.leading,23)
                            Spacer()
                            Text(data.hospital_name)
                                .font(.system(size: 15))
                                .bold()
                                .padding(.trailing,23)
                        }
                        .padding(.top)
                        .padding(.bottom,10)
                        HStack{
                            Text("일정")
                                .font(.system(size: 15))
                                .foregroundStyle(Color.gray)
                                .bold()
                                .padding(.leading,23)
                            Spacer()
                            Text("\(data.date) \(data.time)")
                                .font(.system(size: 15))
                                .bold()
                                .padding(.trailing,23)
                        }
                        .padding(.bottom,10)
                        HStack{
                            Text("의사명")
                                .font(.system(size: 15))
                                .foregroundStyle(Color.gray)
                                .bold()
                                .padding(.leading,23)
                            Spacer()
                            Text(data.staff_name)
                                .font(.system(size: 15))
                                .bold()
                                .padding(.trailing,23)
                        }
                        .padding(.bottom,10)
                        HStack{
                            Text("환자명")
                                .font(.system(size: 15))
                                .foregroundStyle(Color.gray)
                                .bold()
                                .padding(.leading,23)
                            Spacer()
                            Text(data.patient_name)
                                .font(.system(size: 15))
                                .bold()
                                .padding(.trailing,23)
                        }
                        .padding(.bottom,10)
                        Divider()
                            .modifier(ReservationDividerStyleModifier())
                        HStack{
                            Text("전화번호")
                                .bold()
                                .padding(.leading,30)
                                .padding(.top,8)
                            Spacer()
                        }
                        HStack{
                            Text(viewModel.telephone)
                                .padding(.leading,30)
                            Spacer()
                            Text("전화하기")
                                .font(.system(size: 13))
                                .bold()
                                .padding(.horizontal, 10)
                                .padding(.vertical, 10)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.1)))
                                .cornerRadius(10)
                                .foregroundColor(Color("AccentColor"))
                                .onTapGesture {
                                    let telephone = "tel://"
                                    let formattedString = telephone + viewModel.telephone
                                    guard let url = URL(string: formattedString) else { return }
                                    UIApplication.shared.open(url)
                                }
                                .padding(.trailing,30)
                        }
                        Divider()
                            .modifier(ReservationDividerStyleModifier())
                        HStack{
                            Text("위치")
                                .bold()
                                .padding(.leading,30)
                                .padding(.top,8)
                            Spacer()
                        }
                        HStack{
                            Text(viewModel.address)
                                .font(.system(size: 13))
                                .padding(.leading,30)
                                .padding(.top,8)
                            Spacer()
                        }
                        HStack {
                            Spacer() // 좌측에 공간 추가
                            NMFMapViewRepresentable(coord: $viewModel.mapCoord)
                                .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.2) // 원하는 높이로 설정
                                .cornerRadius(20)
                            
                            Spacer() // 우측에 공간 추가
                        }
                        
                    }
                }
                HStack{
                    Spacer()
                    Button{
                        do{
                            try viewModel.requestCencleReservation(reservationId: data.reservation_id)
                        }catch let error as TraceUserError{
                            appManager.displayError(ServiceError: error)
                        }catch{
                            appManager.displayError(ServiceError: .unowned(error.localizedDescription))
                        }
                        
                    } label: {
                        Text("예약취소")
                            .padding()
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.white)
                            .background(Color.gray.opacity(0.5))
                            .cornerRadius(5)
                            .bold()
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                    }
                    Button{
                        appManager.goBack()
                    }label: {
                        Text("확인")
                            .padding()
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity)
                            .foregroundColor(Color.white)
                            .background(Color.blue.opacity(0.5))
                            .cornerRadius(5)
                            .bold()
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                            )
                    }
                    Spacer()
                }
            }
            .normalToastView(toast: $appManager.toast)
            .navigationTitle(viewModel.nameHospital)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                viewModel.setManagerHospitalId(hospitalId: data.hospital_id, appManager: appManager)
                viewModel.setUpDetailView()
            }
        }
        
    }
}

#Preview {
    let re = reservationArray(
            reservation_id: 1,
            hospital_id: 1,
            hospital_name: "asd",
            icon: "asd",
            staff_id: 1,
            staff_name: "asd",
            department_id: ["asd","asd"],
            patient_name: "asd",
            date: "asd",
            time: "asd"
        )
        
    
    ReservationDetailView(data: re)
}
