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

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
