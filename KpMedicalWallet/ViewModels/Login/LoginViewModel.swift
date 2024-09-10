//
//  LoginViewModel.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation

class LoginViewModel: ObservableObject, LoginDataSet{
    
    @Published var checked: Bool = false
    @Published var id: String = ""
    @Published var password: String = ""
    

}
