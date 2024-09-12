//
//  AgreementViewModel.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/12/24.
//

import Foundation
import UIKit

class AgreementViewModel: ObservableObject{
    var appManager: NavigationRouter
    var signUpManager: IdControl? = nil
    //    전체 동의
    @Published var agreeToAll = false
    //    서비스 이용약관
    @Published var agreeToServiceTerms = false
    //    개인정보 수집 및 이용 동의
    @Published var agreeToPrivacyPolicy = false
    //    서비스 알림 수신 동의
    @Published var agreeToPushNotifications = false
    //    버튼 액티브
    @Published var active = false
    
    init(appManager: NavigationRouter) {
        self.appManager = appManager
    }
    
    @MainActor
    func updateAgreeToAll() {
        agreeToAll = agreeToServiceTerms && agreeToPrivacyPolicy && agreeToPushNotifications
    }
    
    @MainActor
    func updateButtonState() {
        active = agreeToServiceTerms && agreeToPrivacyPolicy
    }
    @MainActor
    func routeToSignupView(){
        appManager.push(to: .userPage(item: UserPage(page: .IdCreate), signUpManager: signUpManager))
    }
    func actionAgreeButton() {
        Task{
            signUpManager = IdControl(router: appManager)
            await routeToSignupView()
        }
    }
    
    func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
