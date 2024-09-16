//
//  DobControl.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/12/24.
//

import Foundation

class DobControl: PasswordControl,dobCheckAndSex{
    
    @Published var sexCheck: Bool = false
    
    @Published var DobSexPermission: Bool = false
    
    @Published var viewBirthDate: String = ""
    
    @Published var birthDate: Date = Date()
    
    @Published var nameCheck: Bool = true
    
    @Published var selectedGender: Gender? = nil
    
    override init(router: NavigationRouter) {
        super.init(router: router)
    }
    
    @MainActor
    func dobSetting(){
        viewBirthDate = updateDateViewFormatter()
        dob = updateDateFormatter()
    }
    // 저장 프로미스 dob 값 변경
    private func updateDateFormatter() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: birthDate)
    }
    
    // 뷰 프로미스 값 변경 보이는 값
    private func updateDateViewFormatter() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: birthDate)
    }
    @MainActor
    func sexcodeSet(){
        switch selectedGender {
        case .male:
            sex = "1"
        case .female:
            sex = "2"
        case nil:
            return
        }
    }
    
    @MainActor
    func DobPermissionCheck(){
        if viewBirthDate != "" && selectedGender != nil && name != ""{
            DobSexPermission = true
        }
    }
    
}
enum Gender {
    case male, female
}
