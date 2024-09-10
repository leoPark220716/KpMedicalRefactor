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
    
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(router)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
