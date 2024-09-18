//
//  HospitalDetailViewModel.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/18/24.
//

import Foundation

import SwiftUI

class ScheduleViewModel: ObservableObject {
    @Published var storeHours: [(day: String, open: String, close: String, holiday: Bool)] = []
    
    private let days = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
    
    @MainActor
    func loadSchedules(from schedules: [Schedule]) {
        storeHours = []
        for index in 0..<7 {
            let isDayOffForAll = schedules.allSatisfy { schedule in
                let dayOffIndex = schedule.dayoff.index(schedule.dayoff.startIndex, offsetBy: index)
                return schedule.dayoff[dayOffIndex] == "1"
            }
            if isDayOffForAll {
                storeHours.append((days[index], "", "", true))
            } else {
                let workingSchedules = schedules.filter { schedule in
                    let dayOffIndex = schedule.dayoff.index(schedule.dayoff.startIndex, offsetBy: index)
                    return schedule.dayoff[dayOffIndex] == "0"
                }
                let latestStart = workingSchedules.map { $0.startTime1 }.min() ?? "24:00"
                let earliestEnd = workingSchedules.map { $0.endTime2 }.max() ?? "00:00"
                storeHours.append((days[index], latestStart, earliestEnd, false))
            }
        }
    }
    
    @MainActor
    func EmptyScheduleSetUp(){
        storeHours = [] // 배열을 초기화
        for index in 0..<7 {
            storeHours.append((days[index], "00:00", "00:00", true))
        }
    }
    
    
    func String_currentWeekday() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_KR") // 한국어 설정
            dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul") // 한국어 설정
            dateFormatter.dateFormat = "EEEE" // 요일을 전체 이름으로 표시
            let currentDateString = dateFormatter.string(from: Date())
            return currentDateString
    }
}
