//
//  Tab.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/21/24.
//

import Foundation

struct HomViewResponse: Codable {
    var status: Int
    var success: String
    var message: String
    var data: HomView_Data
}

// 'data' 필드의 구조체
struct HomView_Data: Codable {
    var access_token: String
    var hadConsultation: Bool
    var recommendHospitals: [RecommendedHospital]
    enum CodingKeys: String, CodingKey {
           case access_token, hadConsultation, recommendHospitals
       }
}

// 추천 병원에 대한 구조체
struct RecommendedHospital: Codable {
    var hospital_id: Int
    var icon: String
}
