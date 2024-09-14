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
    @Published var TabViewSelection: TabViewTabs = .home
    

    @MainActor
    override func checkAutoLogin() {
        super.checkAutoLogin()
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
    @MainActor
    func goToRootView(){
        routes = NavigationPath()
    }
    

}
