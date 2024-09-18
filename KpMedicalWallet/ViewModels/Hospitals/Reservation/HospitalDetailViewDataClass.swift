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
    //    의사 프로필 데이터
    @Published var DoctorProfile: [Doctor] = []
    @Published var hospitalIamges: [String] = []
    @Published var marked = false
    @Published var mapCoord = NMGLatLng(lat: 0.0, lng: 0.0)
    
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
}
