//
//  UserNavigation.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation
// 페이지 관리 enum
enum UserViewPage{
    case SearchHospital
    case SearchPassword
    case IdCreate
    case Agreement
    case PasswordCreate
    case DobCreate
    case PhoneCreate
    case SignUpFinal
    
}
enum DefaultPage{
    case login
    case tab
    case splash
}

enum TabViewTabs{
    case home
    case hospital
    case account
}

protocol pages {
    var page: UserViewPage { get }
}

struct UserPage: pages{
    var page: UserViewPage
}
