//
//  HttpRequestModels.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation

struct http<RequestType: Codable, ReturnType: Codable> : Codable{
    var method: String
    var urlParse: String
    var token: String
    var UUID: String
    var requestVal: RequestType?
}

struct KPApiStructFrom<T: Codable>: Codable {
    let status: Int
    let success: String
    let message: String
    let data: T
}
struct KPApiStructFromGetArray<T: Codable>: Codable {
    let status: Int
    let success: String
    let message: String
    let data: [T]
}

