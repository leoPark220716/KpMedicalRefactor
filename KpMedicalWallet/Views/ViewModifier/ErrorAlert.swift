//
//  ErrorAlert.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/14/24.
//

import SwiftUI

struct ErrorAlertModifier: ViewModifier {
    @ObservedObject var errorHandler: GlobalErrorHandler
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: $errorHandler.showError, error: errorHandler.ServiceError) { error in
                Button(PlistManager.shared.string(forKey: "cancel")) {
                    print(error)
                }
                Button(PlistManager.shared.string(forKey: "ok")) {
                    print(error)
                }
            } message: { error in
                Text(error.recoverySuggestion ?? PlistManager.shared.string(forKey: "error_notcatch"))
            }
    }
}

