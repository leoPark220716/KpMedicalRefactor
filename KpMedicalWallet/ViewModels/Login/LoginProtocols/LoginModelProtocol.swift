//
//  LoginModelProtocol.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation

protocol LoginRequest{
    func searchPasswordAction()
    func actionLoginAction()
    func actionSignUpAction()
    
}
protocol LoginDataSet{
    var id: String { get }
    var password: String { get }
    var checked: Bool { get }
}
