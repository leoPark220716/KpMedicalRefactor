//
//  MainView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var appManager: NavigationRouter
    @EnvironmentObject private var errorHandler: GlobalErrorHandler
    
    var body: some View {
        NavigationStack(path: $appManager.routes){
            ZStack{
                switch appManager.RootView {
                case .login:
                    LoginView(appManager: appManager, errorHandler: errorHandler)
                case .tab:
                    DefaultTabView()
                case .splash:
                    SplashView()
                }
            }
            .navigationDestination(for: Route.self) { route in
                route
            }
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var router = NavigationRouter()
        MainView()
            .environmentObject(router)
    }
}

