//
//  HospitalReservationTime.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/19/24.
//

import Foundation
import SwiftUI

class HospitalReservationTime: HospitalReservationEditor{
    @Published var timeSlot: Int = 0
    @Published var reservedTimes: [String] = []
    @Published var startTime1: String = ""
    @Published var endTime1: String = ""
    @Published var startTime2: String = ""
    @Published var endTime2: String = ""
    @Published var selectedTime: String = ""
    @Published var reservation: [Reservation] = []
    @Published var timeIsApper: Bool = false
    
    
    var header: some View {
        HStack {
            Text("시간 선택")
                .font(.system(size: 23))
                .bold()
            Spacer()
        }
        .padding()
    }
    
    var separator: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Color(.init(white: 0, alpha: 0.2)))
            .cornerRadius(10)
            .padding(.bottom, 10)
    }
    
    
    
    var dateInfo: some View {
        VStack {
            Text(reservationData.date)
                .font(.system(size: 14))
                .padding(.leading)
            Text("\(selectedTime)")
                .font(.system(size: 14))
                .padding(.leading)
        }
        .padding(.leading)
    }
    
    var confirmButton: some View {
        Text("확인")
            .bold()
            .padding()
            .font(.system(size: 20))
            .frame(width: 100, height: 40)
            .foregroundColor(Color.white)
            .background(selectedTime.isEmpty ? Color.gray.opacity(0.5) : Color.blue.opacity(0.5))
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(selectedTime.isEmpty ? Color.gray.opacity(0.5) : Color.blue.opacity(0.5), lineWidth: 1)
            )
            .padding(.trailing, 40)
        
    }
    @MainActor
    func setReservationTime(){
        if !selectedTime.isEmpty {
            reservationData.time = self.selectedTime
        }
        
    }
    @MainActor
    private func updateReservations(with value: [Reservation]) {
        reservation = value
        reservedTimes = value.map { $0.time }
        timeSlot = Int(reservationData.time_slot) ?? 10
        startTime1 = getStartTime(for: .startTime1)
        endTime1 = getStartTime(for: .endTime1)
        startTime2 = getStartTime(for: .startTime2)
        endTime2 = getStartTime(for: .endTime2)
        timeIsApper = true
    }
    private func getStartTime(for type: TimeType) -> String {
        switch type {
        case .startTime1:
            return GetStartTime1()
        case .endTime1:
            return GetEndTime1()
        case .startTime2:
            return GetStartTime2()
        case .endTime2:
            return GetEndTime2()
        }
    }
    private enum TimeType {
        case startTime1, endTime1, startTime2, endTime2
    }
    func timeSlotsViewMorning() -> some View {
        let timeSlots = generateTimeSlots(start: startTime1, end: endTime1, slot: timeSlot)
        return ForEach(0..<timeSlots.count, id: \.self) { index in
            let hourSlot = timeSlots[index]
            VStack(alignment: .leading) {
                Text(hourSlot.hourLabel)
                    .font(.system(size: 20))
                    .bold()
                WrapHStack(items: hourSlot.times)
                    .padding(.bottom,30)
            }
        }
    }
    func timeSlotsViewEvning() -> some View {
        let timeSlots = generateTimeSlots(start: startTime2, end: endTime2, slot: timeSlot)
        return ForEach(0..<timeSlots.count, id: \.self) { index in
            let hourSlot = timeSlots[index]
            VStack(alignment: .leading) {
                Text(hourSlot.hourLabel)
                    .font(.system(size: 20))
                    .bold()
                WrapHStack(items: hourSlot.times)
                    .padding(.bottom,30)
            }
        }
    }
    
    func generateTimeSlots(start: String, end: String, slot: Int) -> [HourTimeSlot] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        var slots = [HourTimeSlot]()
        var currentTime = dateFormatter.date(from: start)!
        let endTimeDate = dateFormatter.date(from: end)!
        
        var currentHourSlots = [String]()
        var currentHourLabel = ""
        
        while currentTime < endTimeDate {
            let timeString = dateFormatter.string(from: currentTime)
            let hourLabel = timeLabel(from: currentTime)
            
            if currentHourLabel != hourLabel {
                if !currentHourSlots.isEmpty {
                    slots.append(HourTimeSlot(hourLabel: currentHourLabel, times: currentHourSlots))
                }
                currentHourLabel = hourLabel
                currentHourSlots = [timeString]
            } else {
                currentHourSlots.append(timeString)
            }
            
            currentTime = Calendar.current.date(byAdding: .minute, value: slot, to: currentTime)!
        }
        
        // Add last hour slots if any
        if !currentHourSlots.isEmpty {
            slots.append(HourTimeSlot(hourLabel: currentHourLabel, times: currentHourSlots))
        }
        return slots
    }
    
    func timeLabel(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let hour = dateFormatter.string(from: date)
        let hourInt = Int(hour)!
        return hourInt <= 12 ? "오전 \(hourInt)시" : "오후 \(hourInt-12)시"
    }
    struct HourTimeSlot {
        let hourLabel: String
        let times: [String]
    }
    
    //    오전 시작 시간 출력
    func GetStartTime1() -> String {
        var startTime1 = "00:00"
        if let schedule = DoctorProfile.first(where: {$0.staff_id == reservationData.staff_id}){
            if let findSub = schedule.sub_schedules.first(where: {$0.date == reservationData.date}){
                startTime1 = findSub.startTime1
            }else{
                startTime1 = schedule.main_schedules[0].startTime1
            }
        }
        return startTime1
    }
    //    오전 끝나는 시간 출력
    private func GetEndTime1() -> String {
        var endTime1 = "00:00"
        if let schedule = DoctorProfile.first(where: {$0.staff_id == reservationData.staff_id}){
            if let findSub = schedule.sub_schedules.first(where: {$0.date == reservationData.date}){
                endTime1 = findSub.endTime1
            }else{
                endTime1 = schedule.main_schedules[0].endTime1
            }
        }
        return endTime1
    }
    //    오후 시작 시간 출력
    private func GetStartTime2() -> String {
        var startTime2 = "00:00"
        if let schedule = DoctorProfile.first(where: {$0.staff_id == reservationData.staff_id}){
            if let findSub = schedule.sub_schedules.first(where: {$0.date == reservationData.date}){
                startTime2 = findSub.startTime2
            }else{
                startTime2 = schedule.main_schedules[0].startTime2
            }
        }
        return startTime2
    }
    //    오후 끝나는 시간 출력
    private func GetEndTime2() -> String {
        var endTime2 = "00:00"
        if let schedule = DoctorProfile.first(where: {$0.staff_id == reservationData.staff_id}){
            if let findSub = schedule.sub_schedules.first(where: {$0.date == reservationData.date}){
                endTime2 = findSub.endTime2
            }else{
                endTime2 = schedule.main_schedules[0].endTime2
            }
        }
        return endTime2
    }
    
    
    private func createRequestReservationsDataHospital() throws -> http<Empty?,KPApiStructFrom<RequestReservations>>{
        guard let token = appManager?.jwtToken else{
            throw TraceUserError.clientError(PlistManager.shared.string(forKey: "createRequestStructReservationTimeView"))
        }
        return http<Empty?,KPApiStructFrom<RequestReservations>>(
            method: "GET",
            urlParse: "v2/hospitals/reservations/list/doctor?date=\(reservationData.date)&staff_id=\(reservationData.staff_id)",
            token: token,
            UUID: UserVariable.GET_UUID()
        )
        
    }
    func fetchReservations() {
        Task{
            do{
                let requestData = try createRequestReservationsDataHospital()
                let call = KPWalletAPIManager.init(httpStructs: requestData, URLLocations: 1)
                let response = try await call.performRequest()
                if response.success{
                    if response.data?.status == 200{
                        guard let reservations = response.data?.data.reservations else {
                            await appManager?.displayError(ServiceError: TraceUserError.clientError(PlistManager.shared.string(forKey: "createRequestStructReservationTimeView")))
                            return
                        }
                        await updateReservations(with:reservations)
                    }else{
                        await appManager?.displayError(ServiceError: TraceUserError.clientError(PlistManager.shared.string(forKey: "fetchReservations")))
                    }
                }else{
                    await appManager?.displayError(ServiceError: TraceUserError.clientError(PlistManager.shared.string(forKey: "fetchReservations")))
                }
            }catch let error as TraceUserError{
                await appManager?.displayError(ServiceError: error)
            }catch{
                await appManager?.displayError(ServiceError: .unowned(error.localizedDescription))
            }
        }
    }
    
}
