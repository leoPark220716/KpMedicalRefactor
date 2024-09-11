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
    case SignUp
    case SearchPassword
}
enum DefaultPage{
    case login
    case tab
    case splash
}

protocol pages {
    var page: UserViewPage { get }
}

struct UserPage: pages{
    var page: UserViewPage
}
