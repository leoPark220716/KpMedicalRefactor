//
//  NavigationRouter.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation
import SwiftUI

final class NavigationRouter: UserInfomationManager {
    
    @Published var routes = NavigationPath()
    @Published var RootView: DefaultPage = .splash
    
    override init() {
        super.init()
        if jwtToken == "" {
            RootView = .login
        }else{
            RootView = .tab
        }
    }
    
    @MainActor
    func push(to: Route){
        routes.append(to)
    }
    
    @MainActor
    func rootView(change: DefaultPage){
        RootView = change
    }
    

}
