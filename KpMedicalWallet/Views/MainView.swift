//
//  MainView.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var router: NavigationRouter
    
    var body: some View {
        NavigationStack(path: $router.routes){
            ZStack{
                switch router.RootView {
                case .login:
                    LoginView(router: router)
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

