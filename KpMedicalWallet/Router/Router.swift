//
//  Router.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation


import SwiftUI

enum Route:View, Hashable {
    
    case userPage(item: pages, appManager: NavigationRouter? = nil, signUpManager: IdControl? = nil, errorHandler: GlobalErrorHandler? = nil)
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
    
    static func == (lhs: Route, rhs: Route) -> Bool {
            switch (lhs, rhs) {
            case (.userPage(let lhsItem, _,_,_), .userPage(let rhsItem, _,_,_)):
                return lhsItem.page == rhsItem.page
            }
    }
    var body: some View{
        switch self {
        case .userPage(let item, let appManager, let signUpManager, let errorHandler):
            switch item.page{
            case .SearchHospital:
                EmptyView()
            case .SearchPassword:
                EmptyView()
//                회원가입 섹션
            case .Agreement:
                if let manager = appManager, let errors = errorHandler{
                    AgreementView(appManager: manager,errorHandler: errors)
                }else{
                    ErrorView()
                }
            case .IdCreate:
                if let manager = signUpManager, let errors = errorHandler{
                    SignupIdView()
                        .environmentObject(manager)
                        .environmentObject(errors)
                }else{
                    ErrorView()
                }
            case .PasswordCreate:
                if let manager = signUpManager, let errors = errorHandler{
                    SignupPasswordView()
                        .environmentObject(manager)
                        .environmentObject(errors)
                }else{
                    ErrorView()
                }
            case .DobCreate:
                if let manager = signUpManager, let errors = errorHandler{
                    SignupDobView()
                        .environmentObject(manager)
                        .environmentObject(errors)
                }else{
                    ErrorView()
                }
            case .PhoneCreate:
                if let manager = signUpManager, let errors = errorHandler{
                    SignUpMobileView()
                        .environmentObject(manager)
                        .environmentObject(errors)
                }else{
                    ErrorView()
                }
            case .OtpCreate:
                if let manager = signUpManager, let errors = errorHandler{
                    SignupOtpView()
                        .environmentObject(manager)
                        .environmentObject(errors)
                }else{
                    ErrorView()
                }
            }
            
            
        }
    }
}
