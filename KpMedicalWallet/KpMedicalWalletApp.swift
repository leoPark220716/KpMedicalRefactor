//
//  KpMedicalWalletApp.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import SwiftUI

@main
struct KpMedicalWalletApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var router = NavigationRouter()
    @UIApplicationDelegateAdaptor(FCMDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(router)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear{
                    appDelegate.app = self
                }
        }
    }
}
