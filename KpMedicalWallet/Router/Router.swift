//
//  Router.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation


import SwiftUI

enum Route:View, Hashable {
    
    case userPage(item: pages, appManager: NavigationRouter? = nil)
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
    
    static func == (lhs: Route, rhs: Route) -> Bool {
            switch (lhs, rhs) {
            case (.userPage(let lhsItem, _), .userPage(let rhsItem, _)):
                return lhsItem.page == rhsItem.page
            }
    }
    var body: some View{
        switch self {
        case .userPage(let item, let appManager):
            switch item.page{
            case .SearchHospital:
                EmptyView()
            case .SignUp:
                SignupIdView()
                    .environmentObject(appManager!)
            case .SearchPassword:
                EmptyView()
            case .Agreement:
                if let manager = appManager{
                    AgreementView(appManager: manager)
                }else{
                    EmptyView()
                }
            }
        }
    }
}
