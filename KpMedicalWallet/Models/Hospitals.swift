//
//  Hospitals.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/16/24.
//

import Foundation

struct HospitalRequestQuery {
    var orderby: String = "name"
    var x_tude: String? = nil
    var y_tude: String? = nil
    var key_word: String? = nil
    var department: String? = nil
    var start: Int = 0
    var limit: Int = 30
}

struct Hospitals: Codable, Identifiable, Equatable,Hashable {
    var id: UUID = UUID()
    var hospital_id: Int
    var hospital_name: String
    var icon: String
    var location: String
    var department_id: [String]
    var start_time: String
    var end_time: String
    
    
    enum CodingKeys: String, CodingKey {
        case hospital_id, hospital_name, icon, location, department_id, start_time, end_time
    }
}

struct Hospital_Data: Codable {
    let hospitals: [Hospitals]
}

struct HospitalDataClass: Codable {
    let hospital: Hospital_Detail
    let doctors: [Doctor]
    let error_code :Int
    let error_stack :String
    init() {
        self.hospital = Hospital_Detail() // 여기서 '...'은 Hospital_Detail의 기본값을 나타냄
        self.doctors = [] // 빈 배열 또는 기본 의사 목록
        self.error_code = 0 // 기본 오류 코드 값
        self.error_stack = "" // 기본 오류 스택 값
    }
}
struct Hospital_Detail: Codable {
    var hospital_id: Int
    var hospital_name: String
    var location: String
    var x: Double
    var y: Double
    var phone: String
    var department_id: [String]
    var marked: Int
    var img_url: [String]
    init(hospital_id: Int = 0,
         hospital_name: String = "",
         location: String = "",
         x: Double = 0.0,
         y: Double = 0.0,
         department_id: [String] = [],
         img_url: [String] = [],
         marked: Int = 0) {
        self.hospital_id = hospital_id
        self.hospital_name = hospital_name
        self.location = location
        self.x = x
        self.y = y
        self.phone = ""
        self.department_id = department_id
        self.marked = marked
        self.img_url = img_url
    }
}
struct Doctor: Codable{
    var staff_id: Int
    var name: String
    var icon: String
    var department_id: [String]
    var main_schedules: [Schedule]
    var sub_schedules: [Schedule]
}
struct Schedule: Codable {
    let scheduleId: Int
    let hospitalId: Int
    let staffId: Int
    let startDate: String?
    let endDate: String?
    let date: String?
    let startTime1: String
    let endTime1: String
    let startTime2: String
    let endTime2: String
    let timeSlot: String
    let maxReservation: Int
    let dayoff: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case scheduleId = "schedule_id"
        case hospitalId = "hospital_id"
        case staffId = "staff_id"
        case startDate = "start_date"
        case endDate = "end_date"
        case date
        case startTime1 = "start_time1"
        case endTime1 = "end_time1"
        case startTime2 = "start_time2"
        case endTime2 = "end_time2"
        case timeSlot = "time_slot"
        case maxReservation = "max_reservation"
        case dayoff, name
    }
}
struct RequestReservations: Codable{
    var access_token: String
    var reservations: [Reservation]
    var error_code: Int
    var error_stack: String
}
struct Reservation: Codable {
    var reservation_id: Int
    var hospital_id: Int
    var staff_id: Int
    var date: String
    var time: String
}
struct reservationResponse: Codable{
    var access_token: String
    var reservation_id: Int
    var error_code: Int
    var error_stack: String
}
struct reservationRequest: Codable{
    var hospital_id: Int
    var staff_id: Int
    var date: String
    var time: String
    var purpose: String
    var time_slot: String
}

