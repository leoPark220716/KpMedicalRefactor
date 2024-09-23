//
//  MyReservationView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/20/24.
//

import SwiftUI

struct MyReservationView: View {
    @EnvironmentObject var appManager: NavigationRouter
    @StateObject var viewModel = MyReservationViewModel()
    var body: some View {
        VStack{
            if viewModel.isLoading{
                SomeThingLoading()
            }else if viewModel.reservations.isEmpty{
                SomethingEmpty(text: "에약 내역이 존재하지 않습니다.")
            }else{
                List(viewModel.reservations.indices, id:\.self){ index in
                    Button{
                        viewModel.goToReservationDetailView(index: index)
                    } label: {
                        if index < viewModel.reservations.count{
                            reservationItemView(item: viewModel.reservations[index])
                        }
                    }
                    .onAppear{
                        if index == viewModel.reservations.endIndex - 1 {
                            viewModel.setStart()
                            viewModel.addReservationList()
                        }
                    }
                }
            }
        }
        .normalToastView(toast: $appManager.toast)
        .navigationTitle("에약내역")
        .onAppear{
            print("✅OnApear")
            viewModel.appManager = appManager
            viewModel.setUpMyReservationList()
        }
        .onDisappear{
            print("✅OnDisappear")
            viewModel.initViewDatas()
        }
    }
}

#Preview {
    @Previewable @StateObject var app = NavigationRouter()
    MyReservationView()
        .environmentObject(app)
}
struct reservationItemView: View {
    let item: reservationArray
    @State var TimeCarculate: String = ""
    var body: some View {
        VStack {
            HStack{
                VStack(alignment: .leading){
                    HStack{
                        Text(item.hospital_name)
                            .modifier(ReservationListHospitalNameModifier())
                        Spacer()
                        Text(TimeCarculate)
                            .modifier(ReservationListTimeModifier())
                    }
                    .padding(.bottom,4)
                    HStack{
                        Text("환자명 |")
                            .modifier(ReservationListTextModifier(color: Color.gray))
                        Text(item.patient_name)
                            .modifier(ReservationListTextModifier(color: Color.black))
                    }
                    .padding(.bottom,2)
                    HStack{
                        Text("예약시간 |")
                            .modifier(ReservationListTextModifier(color: Color.gray))
                        Text("\(item.date) \(item.time)")
                            .modifier(ReservationListTextModifier(color: Color.black))
                    }
                    .padding(.bottom,2)
                    HStack{
                        Text("의사 |")
                            .modifier(ReservationListTextModifier(color: Color.gray))
                        Text(item.staff_name)
                            .modifier(ReservationListTextModifier(color: Color.black))
                        Spacer()
                    }
                    HStack {
                        ForEach(item.department_id.prefix(4), id: \.self) { id in
                            let intid = Int(id)
                            if let department = Department(rawValue: intid ?? 0) {
                                Text(department.name)
                                    .modifier(HospitalsDepartmentTexts())
                            }
                        }
                        if item.department_id.count > 4 {
                            Text("...")
                        }
                    }
                }
            }
        }
        .background(Color.white)
        .padding(.vertical,5)
        .onAppear{
            let timezone = TimeZone(identifier: "Asia/Seoul")!
            var calendar = Calendar.current
            calendar.timeZone = timezone

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            dateFormatter.timeZone = timezone

            // 주어진 날짜와 시간으로 Date 객체 생성
            if let visitDate = dateFormatter.date(from: "\(item.date) \(item.time)"){
                // 현재 날짜와 시간
                let currentDate = Date()
                // 방문 시간까지 남은 시간 (초 단위)
                let timeInterval = visitDate.timeIntervalSince(currentDate)
                if timeInterval < 0 {
                    // 이미 지난 시간
                    TimeCarculate = "종료"
                } else {
                    // 남은 시간을 시간과 일로 변환
                    let hours = timeInterval / 3600
                    let days = hours / 24
                    if hours < 24 {
                        TimeCarculate = "\(Int(hours)) 시간 후 방문"
                    } else {
                        TimeCarculate = "\(Int(days)) 일 후 방문"
                    }
                }
            } else {
                print("날짜 형식이 올바르지 않습니다.")
            }
        }
    }
}

//#Preview {
//    reservationItemView()
//}
