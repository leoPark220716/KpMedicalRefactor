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

struct AutoLoginModel: Codable {
    let access_token: String
    let name: String
    let dob: String
    let sex_code: String
    let isHospitalRegistered: String?
    let staffData: String?
    let error_code: Int?
    let error_stack: String?
}



struct SingupRequestModul: Codable {
    let account: String
    let password: String
    let mobile: String
    let name: String
    let dob: String
    let sex_code: String
}


struct UserData: Codable, User, HaveJWT {
    var name: String
    var dob: String
    var sex: String
    var jwtToken: String
    
    enum CodingKeys: String, CodingKey {
            case name
            case dob
            case sex = "sex_code"
            case jwtToken = "access_token"
        }
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
struct deleteResponse: Codable{
    let affectedRows: Int
    let error_code: Int
    let error_stack: String
}
struct FcmToken:Codable{
    struct FcmTokenSend: Codable{
        var fcm_token:String
    }
    struct FcmTokenResponse: Codable{
        var affectedRows: Int
        var error_code: Int
        var error_stack: String
    }
    
}
