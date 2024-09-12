//
//  OtpControl.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/12/24.
//

import Foundation

class OtpControl: SignUpDataModel,OtpCheck{
    @Published var otpCheck: Bool = false
    override init(router: NavigationRouter) {
        super.init(router: router)
    }
}
