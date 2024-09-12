//
//  PhoneNumberControl.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/12/24.
//

import Foundation

class PhoneNumberControl:OtpControl, PhonNumberCheck{
    @Published var numberCheck: Bool = false
    override init(router: NavigationRouter) {
        super.init(router: router)
    }
}
