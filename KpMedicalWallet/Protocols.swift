//
//  Protocols.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation


protocol UserManager: User{
    var loginStatus: Bool { get }
    func GetUserAccountString() -> (status: Bool, account: String)
}

protocol User{
    var name: String { get }
    var dob: String { get }
    var sex: String { get }
}

protocol HaveJWT{
    var jwtToken: String { get }
}
protocol HaveFCMToken{
    var fcmToken: String { get }
    func refreshFCMToken()
    func deleteFCMToken()
}

protocol SignUpData: User{
    var phone: String { get }
    var account: String { get }
    var password: String { get }
    var otp: String { get }
    var router: NavigationRouter { get }
    
}

protocol UserAccountHandle: SignUpData{
    var idCheck: Bool { get }
    var IdFieldStatus: Bool { get }
}

protocol passwordCheck: SignUpData{
    var passwordCheck: Bool { get }
    var passwordSecond: String { get }
    var PassFieldStatus: Bool { get }
    var SecondPassFieldStatus: Bool { get }
}
protocol dobCheckAndSex: SignUpData{
    var sexCheck: Bool { get }
}

protocol PhonNumberCheck: SignUpData{
    var numberCheck: Bool { get }
}
protocol OtpCheck: SignUpData{
    var otpCheck: Bool { get }
    var verifyToken: String { get }
    var otpViewShow: Bool { get }
}
