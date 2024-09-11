//
//  GlobalErrorHandler.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/11/24.
//

import Foundation
import SwiftUI
import Combine

class GlobalErrorHandler: ObservableObject {
    @Published var showError: Bool = false
    var ServiceError : TraceUserError? = nil
    
    @MainActor
    func displayError( ServiceError: TraceUserError) {
        print("displayError")
        self.showError = true
        self.ServiceError = ServiceError
    }
}
