//
//  ReservationTimeChooseView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/19/24.
//

import SwiftUI
import Combine

struct ReservationTimeChooseView: View {
    @EnvironmentObject var viewModel: HospitalReservationModel
    var body: some View {
        VStack{
            viewModel.header
            ScrollView{
                if viewModel.timeIsApper{
                    TimeChoseScroll()
                }
            }
            viewModel.separator
            
            HStack {
                viewModel.dateInfo
                Spacer()
                Button{
                    viewModel.setReservationTime()
                    viewModel.goToSymptomEditorView()
                } label: {
                    viewModel.confirmButton
                }.disabled(viewModel.selectedTime.isEmpty)
                
            }
            
        }
        .background(Color.gray.opacity(0.09))
        .onAppear {
            viewModel.fetchReservations()
        }
        .onDisappear{
            viewModel.selectedTime = ""
        }
        .navigationTitle("예약 시간을 선택해주세요")
    }
}

#Preview {
    ReservationTimeChooseView()
}
struct WrapHStack: View {
    @EnvironmentObject var viewModel: HospitalReservationModel
    var items: [String]
    var body: some View {
        HStack { // HStack을 추가하여 중앙 정렬
            Spacer()
            let columns = [GridItem(.adaptive(minimum: 70))]
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(items, id: \.self) { time in
                    if !viewModel.reservedTimes.contains(time) {
                        Text(time)
                            .bold()
                            .font(.system(size: 29))
                            .padding()
                            .frame(width: 75, height: 30)
                            .background(Color.white)
                            .foregroundColor(viewModel.selectedTime == time ? Color.blue : Color.black)
                            .cornerRadius(10)
                            .minimumScaleFactor(0.5) // 텍스트 크기가 잘리지 않도록 조정
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(viewModel.selectedTime == time ? Color.blue : Color.black, lineWidth: 1)
                            )
                            .onTapGesture {
                                viewModel.selectedTime = time // 사용자가 탭할 때 selectedTime을
                            }
                    }
                }
            }
            Spacer()
        }
    }
}
struct TimeChoseScroll: View {
    @EnvironmentObject var viewModel: HospitalReservationModel
    var body: some View{
        VStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 15){
                    viewModel.timeSlotsViewMorning()
                    viewModel.timeSlotsViewEvning()
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
    }
}
