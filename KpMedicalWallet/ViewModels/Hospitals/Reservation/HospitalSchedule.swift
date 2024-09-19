//
//  HospitalSchedule.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/18/24.
//

import Foundation


class HospitalSchedule: HospitalDoctor{
    @Published var closeDate: [String] = []
    @Published var openDate: [String] = []
    @Published var disalbeWeek: Set<Int> = []
    @Published var selectedDate: Date? = nil{
        didSet{
            Task{
                await returnSetTrue()
            }
            
        }
    }
    @Published var isReadyToShowCalendar = false
    @Published var scheduleButtonState: Bool = false
    
    let today = Date()
    
    var isSetDoctor: Bool {
        return reservationData.staff_id != 0
    }
    @MainActor
    func returnSetTrue(){
        scheduleButtonState = true
    }
    @MainActor
    func DateReservationSet(){
        reservationData.date = formatDate()
    }
    
    func FindEveryDoctorDayoff(){
        //        메인 스케줄 기반으로 휴일 찾기
        for index in 0..<7 {
            let isDayOffForAll = HospitalSchedules.allSatisfy { schedule in
                let dayOffIndex = schedule.dayoff.index(schedule.dayoff.startIndex, offsetBy: index)
                return schedule.dayoff[dayOffIndex] == "1"
            }
            // 모든 스케줄이 특정 요일에 휴무일이면 true 를 반환 여기서 병원의 휴무일을 찾는다.
            if isDayOffForAll {
                // 토요일(6)인 경우 1(일요일)로 설정, 그 외는 index + 2
                // 여기서 % 7을 사용하여 주간의 순환을 처리
                disalbeWeek.insert((index + 1) % 7 + 1)
            }
        }
    }
    
    //    SubSchedule 는 의사 개인 설정을 통해 출근과 휴무를 표현한 것이기에 넣는다. 무족건 출근하는날
    func setOpenDateDidntChooseDoctor(){
        for index in 0..<HospitalSubSchedules.count {
            if HospitalSubSchedules[index].dayoff == "0"{
                guard let date = HospitalSubSchedules[index].date else{
                    continue
                }
                openDate.append(date)
            }
        }
    }
    
    func setDayOffDateDidntChooseDoctor(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // 모든 의사의 sub_schedules를 조사하여 병원이 문을 닫아야 하는 날짜를 파악합니다.
        var datesWhenAllDoctorsOff = [String: Int]() // 의사들이 휴무인 날짜와 그 날 휴무인 의사 수를 저장합니다.
        var datesWhenAnyDoctorWorks = Set<String>() // 적어도 한 명의 의사가 출근하는 날짜를 저장합니다.
        
        for doctor in DoctorProfile {
            for schedule in doctor.sub_schedules {
                guard let date = schedule.date else { continue }
                if schedule.dayoff == "1" {
                    // 의사가 휴식을 취하는 날
                    datesWhenAllDoctorsOff[date, default: 0] += 1
                } else {
                    // 의사가 출근하는 날
                    datesWhenAnyDoctorWorks.insert(date)
                }
            }
        }
        // 모든 의사가 휴무인 날짜만을 추출합니다.
        for (date, count) in datesWhenAllDoctorsOff {
            if count == DoctorProfile.count && !datesWhenAnyDoctorWorks.contains(date) {
                // 모든 의사가 휴무이고, 아무도 출근하지 않는 날짜를 closeDate에 추가합니다.
                closeDate.append(date)
            }
        }
    }
    
    func setDayOffDateDidChooseDoctor(){
        let subSchedule = GetDoctorSubSchedules()
        for index in 0..<subSchedule.count {
            if subSchedule[index].dayoff == "1"{
                guard let date = subSchedule[index].date else{
                    continue
                }
                closeDate.append(date)
                print("무족건 문 닫는날 \(date)")
            }
        }
    }
    func setOpenDateDidChooseDoctor(){
        let subSchedule = GetDoctorSubSchedules()
        for index in 0..<subSchedule.count {
            if subSchedule[index].dayoff == "0"{
                guard let date = subSchedule[index].date else{
                    continue
                }
                openDate.append(date)
                print("무족건 문 여는날 \(date)")
            }
        }
    }
    
    //    의사 선택 x 실행 함수
    @MainActor
    func didntSetDoctorViewSetting(){
        FindEveryDoctorDayoff()
        setDayOffDateDidntChooseDoctor()
        setOpenDateDidntChooseDoctor()
        isReadyToShowCalendar = true
    }
    
    // 의사 선택 후 실행 함수
    @MainActor
    func didSetDoctorViewSetting(){
        FindEveryDoctorDayoff()
        setOpenDateDidChooseDoctor()
        setDayOffDateDidChooseDoctor()
        isReadyToShowCalendar = true
        
    }
    func caseChooseDoctor(){
        Task{
            switch isSetDoctor{
            case true:
                await didSetDoctorViewSetting()
                
            case false:
                await didntSetDoctorViewSetting()
            }
        }
        
    }
    func formatDate() -> String {
        guard let date = selectedDate else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
}

