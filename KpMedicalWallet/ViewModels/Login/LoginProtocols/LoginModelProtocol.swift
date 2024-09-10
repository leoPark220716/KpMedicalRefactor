//
//  LoginModelProtocol.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation

protocol LoginRequest{
    func LoginCheck() -> (error: Bool, token: String)
}
protocol LoginDataSet{
    var id: String { get }
    var password: String { get }
    var checked: Bool { get }
}
