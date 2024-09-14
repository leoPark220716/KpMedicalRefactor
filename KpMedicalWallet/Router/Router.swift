//
//  Router.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation


import SwiftUI

enum Route:View, Hashable {
    
    case userPage(item: pages, appManager: NavigationRouter? = nil, signUpManager: IdControl? = nil, errorHandler: GlobalErrorHandler? = nil,pageStatus: Bool? = nil,name: String? = nil)
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
    
    static func == (lhs: Route, rhs: Route) -> Bool {
            switch (lhs, rhs) {
            case (.userPage(let lhsItem, _,_,_,_,_), .userPage(let rhsItem, _,_,_,_,_)):
                return lhsItem.page == rhsItem.page
            }
    }
    var body: some View{
        switch self {
        case .userPage(let item, let appManager, let signUpManager, let errorHandler,let pageStatus, let name):
            switch item.page{
            case .SearchHospital:
                HospitalListMain()
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
                if let manager = signUpManager{
                    SignupIdView()
                        .environmentObject(manager)
                }else{
                    ErrorView()
                }
            case .PasswordCreate:
                if let manager = signUpManager{
                    SignupPasswordView()
                        .environmentObject(manager)
                }else{
                    ErrorView()
                }
            case .DobCreate:
                if let manager = signUpManager{
                    SignupDobView()
                        .environmentObject(manager)
                }else{
                    ErrorView()
                }
            case .PhoneCreate:
                if let manager = signUpManager{
                    SignUpMobileView()
                        .environmentObject(manager)
                }else{
                    ErrorView()
                }
            
            case .SignUpFinal:
                if let pageStatus = pageStatus, let name = name{
                    SignupFinalView(pageStatus:pageStatus,name: name)
                }else{
                    ErrorView()
                }
                
                
                //
            }
            
            
        }
    }
}
