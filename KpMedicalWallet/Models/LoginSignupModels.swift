//
//  LoginSignupModels.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation


struct LoginModul: Codable {
    let account: String
    let password: String
    let uid: String
}
struct SingupRequestModul: Codable {
    let account: String
    let password: String
    let mobile: String
    let name: String
    let dob: String
    let sex_code: String
}

struct LoginResponse: Codable {
    let access_token: String
    let name: String
    let dob:String
    let sex_code: String
}

struct normal_Toast: Equatable {
    var message: String
    var duration: Double = 3
}
struct IDCheckResponse: Codable {
    let account: String
}
struct MobileResponse: Codable {
    let verify_token: String
}
struct OtpResponse: Codable {
    let mobile: String
    let service_id: Int
    let iat: Int
    let exp: Int
}
