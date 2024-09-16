//
//  GlobalErrorHandler.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/11/24.
//

import Foundation
import SwiftUI

class GlobalErrorHandler: ObservableObject {
    @Published var showError: Bool = false
    @Published var ServiceError : TraceUserError? = nil
    
    
    @MainActor
    func displayError( ServiceError: TraceUserError) {
        self.showError = true
        self.ServiceError = ServiceError
    }
}
