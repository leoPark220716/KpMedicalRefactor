//
//  tests.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/21/24.
//

import Foundation

class tests: ObservableObject{
    @Published var viewModel: HospitalListMainViewModel? = nil
    
     func create (viewModel: HospitalListMainViewModel? = nil) {
        self.viewModel = viewModel
        viewModel?.myHospitalListSetUp()
    }
    deinit {
        self.viewModel = nil
    }
}
