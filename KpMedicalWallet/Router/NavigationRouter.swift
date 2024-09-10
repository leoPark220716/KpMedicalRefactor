//
//  NavigationRouter.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation
import SwiftUI

final class NavigationRouter: UserInfomationManager, ObservableObject {
    
    @Published var routes = NavigationPath()
    @Published var RootView: DefaultPage = .splash
    
    override init() {
        super.init()
        if token == "" {
            RootView = .login
        }else{
            RootView = .tab
        }
    }
    
    override func SetInfo(datas: LoginResponse) {
        super.SetInfo(datas: datas)
        RootView = .tab
    }
    
    
}
