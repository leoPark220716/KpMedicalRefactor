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
    func displayError(ServiceError: Error) {
        print("❌ Error : \(ServiceError.self)")
        if let traceError = ServiceError as? TraceUserError{
            self.showError = true
            self.ServiceError = traceError
        }else{
            self.showError = true
            self.ServiceError = .unowned(ServiceError.localizedDescription)
        }
    }
    @MainActor
    func displayError(ServiceError: TraceUserError) {
        print("❌ Error : \(ServiceError.self)")
            self.showError = true
            self.ServiceError = ServiceError
        
    }
}
