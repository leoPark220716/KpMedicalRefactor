//
//  HospitalDetailViewDataClass.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/18/24.
//

import Foundation
import NMapsMap

class HospitalDetailViewDataClass: ObservableObject{
    @Published var HospitalSchedules: [Schedule] = []
    @Published var HospitalSubSchedules: [Schedule] = []
    //    의사 프로필 데이터
    @Published var DoctorProfile: [Doctor] = []
    @Published var hospitalIamges: [String] = []
    @Published var marked = false
    @Published var mapCoord = NMGLatLng(lat: 0.0, lng: 0.0)
    @Published var hospitalDepartments: [Int] = []
    @Published var reservationData = reservationInfo()
    
    
    var hospitalId: String? = nil
    var appManager: NavigationRouter?
    
    
    func setManagerHospitalId(hospitalId: Int, appManager: NavigationRouter){
        self.hospitalId = String(hospitalId)
        self.appManager = appManager
    }
    
    func checkTimeIn(startTime: String, endTime: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        dateFormatter.dateFormat = "HHmm"
        guard let now = Int(dateFormatter.string(from: Date())),
              let st = Int(startTime.replacingOccurrences(of: ":", with: "")),
              let en = Int(endTime.replacingOccurrences(of: ":", with: "")) else {
            // 날짜 변환이 실패했을 경우
            return false
        }
        return now >= st && now <= en
    }
    
    //    특정 의사의 메인 스케줄 반환
    func GetDoctorMainSchedules() -> [Schedule] {
        // doctors 배열에서 staff_id가 주어진 staff_id와 일치하는 의사를 찾습니다.
        if let doctor = DoctorProfile.first(where: { $0.staff_id == reservationData.staff_id }) {
            // 해당 의사의 main_schedules를 반환합니다.
            return doctor.main_schedules
        } else {
            // 일치하는 의사가 없는 경우, 빈 배열을 반환합니다.
            return []
        }
    }
    // 특정 의사의 서브 스케줄 반환
    func GetDoctorSubSchedules() -> [Schedule] {
        // doctors 배열에서 staff_id가 주어진 staff_id와 일치하는 의사를 찾습니다.
        if let doctor = DoctorProfile.first(where: { $0.staff_id == reservationData.staff_id }) {
            // 해당 의사의 main_schedules를 반환합니다.
            return doctor.sub_schedules
        } else {
            // 일치하는 의사가 없는 경우, 빈 배열을 반환합니다.
            return []
        }
    }
    //   진료과 보유 의사 반환
    func GetDepartHaveDoctor() -> [Doctor]{
        return DoctorProfile.filter{
            $0.department_id.contains(String(reservationData.department_id))
        }
    }
    func findWorkingStaffIds(on date: String, from doctors: [Doctor]) -> [Int] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let targetDate = dateFormatter.date(from: date) else {
            print("Invalid date format")
            return []
        }
        
        var workingStaffIds: [Int] = []
        
        for doctor in doctors {
            // sub_schedules에서 휴무 확인
            let isOffDayInSubSchedule = doctor.sub_schedules.contains { subSchedule in
                subSchedule.date == date && subSchedule.dayoff == "1"
            }
            let isOnDay = doctor.sub_schedules.contains { subSchedule in
                subSchedule.date == date && subSchedule.dayoff == "0"
            }
            if isOnDay{
                workingStaffIds.append(doctor.staff_id)
                continue
            }
            // sub_schedules에서 휴무로 명시된 경우 다음 의사 검사로 이동
            if isOffDayInSubSchedule {
                continue
            }
            
            // main_schedules에서 출근 여부 확인
            for mainSchedule in doctor.main_schedules {
                guard let startDate = dateFormatter.date(from: mainSchedule.startDate ?? ""),
                      let endDate = dateFormatter.date(from: mainSchedule.endDate ?? ""),
                      startDate...endDate ~= targetDate else {
                    continue
                }
                
                // 요일을 1부터 시작하는 인덱스로 변경 (월요일이 1, 일요일이 7)
                let dayOfWeek = Calendar.current.component(.weekday, from: targetDate)
                let adjustedDayOfWeek = dayOfWeek == 1 ? 6 : dayOfWeek - 2 // 월요일을 1로 조정합니다.
                
                if mainSchedule.dayoff.count > adjustedDayOfWeek {
                    let startIndex = mainSchedule.dayoff.index(mainSchedule.dayoff.startIndex, offsetBy: adjustedDayOfWeek)
                    let dayOffCharacter = mainSchedule.dayoff[startIndex]
                    
                    let isWorkDay = dayOffCharacter == "0" // "0"은 출근을 의미합니다.
                    // 출근일 경우 결과에 추가
                    if isWorkDay {
                        workingStaffIds.append(doctor.staff_id)
                        break // 다음 main_schedule 검사는 필요 없음
                    }
                }
            }
            
        }
        print("idCheck \(workingStaffIds)")
        return workingStaffIds
    }
    // 닥터 아이디에 있는 Doctor 배열 출력
    func GetDoctorGetIDArry(staff_id: [Int]) -> [Doctor] {
        var doc: [Doctor] = []
        for item in staff_id{
            for doctorAr in DoctorProfile{
                if item == doctorAr.staff_id{
                    doc.append(doctorAr)
                }
            }
        }
        return doc
    }
    
    
    
}
struct reservationInfo {
    var hospital_id: Int
    var staff_id: Int
    var date: String
    var time: String
    var purpose: String
    var time_slot: String
    var department_id: Int
    var hospital_name: String
    var doc_name: String
    var symptom: String
    
    init() {
        self.hospital_id = 0
        self.staff_id = 0
        self.date = ""
        self.time = ""
        self.purpose = ""
        self.time_slot = ""
        self.department_id = 9999999
        self.hospital_name = ""
        self.doc_name = ""
        self.symptom = ""
    }
    mutating func setDate(date: String){
        self.date = date
    }
}
