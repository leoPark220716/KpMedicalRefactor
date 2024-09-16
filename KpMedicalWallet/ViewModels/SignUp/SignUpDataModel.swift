//
//  SignUpControls.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/12/24.
//

import Foundation

class SignUpDataModel: SignUpData,ObservableObject {
    var appManager: NavigationRouter
    
    
    @Published var phone: String = ""
    @Published var account: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var dob: String = ""
    @Published var sex: String = ""
    @Published var otp: String = ""
    
    init(router: NavigationRouter) {
        print("✅ Signup Class Init")
        self.appManager = router
    }
    deinit{
        print("❌ Signup Class DeInit")
    }
}
