//
//  Protocols.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation


protocol UserManager{
    var name: String { get }
    var dob: String { get }
    var sex: String { get }
    var token: String { get }
    var fcmToken: String { get }
    var loginStatus: Bool { get }
}
protocol UserAuthData{
    var name: String { get }
    var dob: String { get }
    var sex: String { get }
    var token: String { get }
}
