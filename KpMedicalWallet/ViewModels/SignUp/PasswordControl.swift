//
//  PasswordControl.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/12/24.
//

import Foundation


class PasswordControl: PhoneNumberControl, passwordCheck{
    
    @Published var passwordCheck: Bool = false
    
    @Published var passwordSecond: String = ""
    
    @Published var PassFieldStatus: Bool = false
    
    @Published var SecondPassFieldStatus: Bool = false
    override init(router: NavigationRouter) {
        super.init(router: router)
    }
    
}
