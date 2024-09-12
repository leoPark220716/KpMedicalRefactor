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
    
    @Published var PassFieldStatus: Bool = true
    
    @Published var SecondPassFieldStatus: Bool = false
    
    @Published var PasswordPermission: Bool = false
    
    override init(router: NavigationRouter,errorHandler: GlobalErrorHandler) {
        super.init(router: router, errorHandler: errorHandler)
    }
    
    @MainActor
    func detechPasswordField(text: String){
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*])[A-Za-z\\d!@#$%^&*]{8,30}$"
        let isMatchingRegex = NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: text)
        PassFieldStatus = isMatchingRegex
    }
    @MainActor
    func PasswordResetStatus(text: String){
        if text == "" {
            PassFieldStatus = true
        }
    }
    @MainActor
    func detechPasswordFieldSecond(text: String){
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*])[A-Za-z\\d!@#$%^&*]{8,30}$"
        let isMatchingRegex = NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: text)
        SecondPassFieldStatus = isMatchingRegex
        PasswordPermission = false
        matchPassword()
    }
    
    @MainActor
    func PasswordResetStatusSecond(text: String){
        if text == "" {
            SecondPassFieldStatus = true
        }
    }
    
    @MainActor
    private func matchPassword(){
        if passwordSecond == password{
            PasswordPermission = true
        }
    }
}
