//
//  SignUpControls.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/12/24.
//

import Foundation

class SignUpDataModel: SignUpData,ObservableObject {
    var router: NavigationRouter
    
    @Published var phone: String = ""
    @Published var account: String = "테스트입니다"
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var dob: String = ""
    @Published var sex: String = ""
    @Published var otp: String = ""
    
    init(router: NavigationRouter) {
        self.router = router
        
    }
}
