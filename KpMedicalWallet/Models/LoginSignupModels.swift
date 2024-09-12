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
