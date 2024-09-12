//
//  DobControl.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/12/24.
//

import Foundation

class DobControl: PasswordControl,dobCheckAndSex{
    @Published var nameCheck: Bool = false
    
    @Published var dobCheck: Bool = false
    
    @Published var sexCheck: Bool = false
    override init(router: NavigationRouter) {
        super.init(router: router)
    }
    
}
