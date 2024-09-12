//
//  IdControl.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/12/24.
//

import Foundation

class IdControl: DobControl,UserAccountHandle{
    var idCheck: Bool = false
    var IdFieldStatus: Bool = false
    override init(router: NavigationRouter) {
        super.init(router: router)
    }
    
    @MainActor
    func movePasswordView(){
        router.push(to: .userPage(item: UserPage(page: .PasswordCreate), signUpManager: self))
    }
    @MainActor
    func moveDobView(){
        router.push(to: .userPage(item: UserPage(page: .DobCreate), signUpManager: self))
    }
    @MainActor
    func movePhonView(){
        router.push(to: .userPage(item: UserPage(page: .PhoneCreate), signUpManager: self))
    }
    @MainActor
    func moveOtpView(){
        router.push(to: .userPage(item: UserPage(page: .OtpCreate), signUpManager: self))
    }
    @MainActor
    func goBackLoginView(){
        router.goToRootView()
    }
    
}
