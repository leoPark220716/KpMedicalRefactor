//
//  HospitalDetailScheduleView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/18/24.
//

import SwiftUI

struct HospitalScheduleView: View{
    @Binding var HospitalSchedules: [Schedule]
    @StateObject var viewModel = ScheduleViewModel()
    
    
    var body: some View{
        if !HospitalSchedules.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(viewModel.storeHours, id: \.day) { schedule in
                    HStack {
                        Spacer()
                        Text(schedule.day)
                            .modifier(HospitalDetailScheduleModify(schedule: schedule.day, width: 50, aligment: .leading))
                            .fontWeight(schedule.day == viewModel.String_currentWeekday() ? .bold : .regular)
                        
                        Spacer()
                        Text(schedule.holiday ? "휴무" : "\(schedule.open)~\(schedule.close)")
                            .modifier(HospitalDetailScheduleModify(schedule: schedule.day,width: 110, aligment: .center))
                            .fontWeight(schedule.day == viewModel.String_currentWeekday() ? .bold : .regular)
                        
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .onAppear {
                viewModel.loadSchedules(from: HospitalSchedules)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.1)))
            .padding(.horizontal)
        }
        else{
            VStack(alignment: .leading, spacing: 10) {
                ForEach(viewModel.storeHours, id: \.day) { schedule in
                    HStack {
                        Spacer()
                        Text(schedule.day)
                            .modifier(HospitalDetailEmptyScheduleModify(schedule: schedule.day, width: 50,aligment: .leading))
                        Spacer()
                        Text(schedule.holiday ? "휴무" : "\(schedule.open)~\(schedule.close)")
                            .modifier(HospitalDetailEmptyScheduleModify(schedule: schedule.day, width: 110,aligment: .center))
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .onAppear {

                viewModel.EmptyScheduleSetUp()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.1)))
            .padding(.horizontal)
        }
    }
    
}

