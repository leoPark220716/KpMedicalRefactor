//
//  Router.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation


import SwiftUI
enum Route:View, Hashable {
    
    case userPage(item: pages)
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
    
    static func == (lhs: Route, rhs: Route) -> Bool {
        switch(lhs, rhs){
        case (.userPage(let lhsItem),.userPage(let rhsItem)):
            return lhsItem.page == rhsItem.page
        }
    }
    
    var body: some View{
        switch self {
        case .userPage(let item):
            switch item.page{
            case .home:
                LoginView()
            case .login:
                LoginView()
            case .signup:
                LoginView()
            }
            
        }
    }
}
