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
    case HospitalDetail
    
    case chooseDepartment
    case chooseDoctor
    case chooseDate
    case chooseTime
    case reservationSymptom
    case reservationFinal
    
    case myReservationView
    case reservationDetail
    
    case walletMain
    case walletPassword
    case walletMnemonic
    case walletRecover

    case SearchPassword
    case IdCreate
    case Agreement
    case PasswordCreate
    case DobCreate
    case PhoneCreate
    case SignUpFinal
    
    case advice
    case images
}
enum DefaultPage{
    case login
    case tab
    case splash
}

enum TabViewTabs{
    case home
    case chat
    case hospital
    case account
}

protocol pages {
    var page: UserViewPage { get }
}

struct UserPage: pages{
    var page: UserViewPage
}
