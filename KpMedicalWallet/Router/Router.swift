//
//  Router.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation


import SwiftUI

enum Route:View, Hashable {
    
    case userPage(item: pages, appManager: NavigationRouter? = nil, signUpManager: IdControl? = nil, pageStatus: Bool? = nil,name: String? = nil,Hospital: Hospitals? = nil, reservationModel: HospitalReservationModel? = nil, reservation: reservationArray? = nil, walletModel: KPHWallet? = nil, hospitalId: Int? = nil, hospitalName: String? = nil)
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
    
    static func == (lhs: Route, rhs: Route) -> Bool {
            switch (lhs, rhs) {
            case (.userPage(let lhsItem, _,_,_,_,_,_,_,_,_,_), .userPage(let rhsItem, _,_,_,_,_,_,_,_,_,_)):
                return lhsItem.page == rhsItem.page
            }
    }
    var body: some View{
        switch self {
        case .userPage(let item, let appManager, let signUpManager,let pageStatus, let name,let hospital, let reservationModel, let reservation,let walletModel, let hospitalId, let HospitalName):
            switch item.page{
            case .SearchHospital:
                HospitalListMain()
            case .HospitalDetail:
                if let hospital = hospital{
                    HospitalDetailView(hospitalInfo: hospital)
                }else{
                    ErrorView()
                }
                
            case .chooseDepartment:
                if let reservationModel = reservationModel{
                    ReservationDepartmentView()
                        .environmentObject(reservationModel)
                }else{
                    ErrorView()
                }
            case .chooseDoctor:
                if let reservationModel = reservationModel{
                    ReservationDoctorChooseView()
                        .environmentObject(reservationModel)
                }else{
                    ErrorView()
                }
            case .chooseDate:
                if let reservationModel = reservationModel{
                    ReservationDateChooseView()
                        .environmentObject(reservationModel)
                }else{
                    ErrorView()
                }
            case .chooseTime:
                if let reservationModel = reservationModel{
                    ReservationTimeChooseView()
                        .environmentObject(reservationModel)
                }else{
                    ErrorView()
                }
            case .reservationSymptom:
                if let reservationModel = reservationModel{
                    ReservationSymptomView()
                        .environmentObject(reservationModel)
                }else{
                    ErrorView()
                }
            case .reservationFinal:
                if let reservationModel = reservationModel{
                    ReservationFinalView()
                        .environmentObject(reservationModel)
                }else{
                    ErrorView()
                }
            case .myReservationView:
                MyReservationView()
                
            case .reservationDetail:
                if let reservation = reservation{
                    ReservationDetailView(data: reservation)
                }else{
                    ErrorView()
                }
                // 지갑뷰
            case .walletMain:
                WalletMainView()
            
            case .walletPassword:
                if let appManager = appManager, let walletModel = walletModel{
                    WalletPasswordEditor(appManager: appManager)
                        .environmentObject(walletModel)
                }else{
                    ErrorView()
                }
                
            case .walletMnemonic:
                if let walletModel = walletModel{
                    WalletMnemonicView()
                        .environmentObject(walletModel)
                }else{
                    ErrorView()
                }
                
            case .walletRecover:
                if let appManager = appManager,let walletModel = walletModel{
                    WalletRecoverView(appManager: appManager)
                        .environmentObject(walletModel)
                }else{
                    ErrorView()
                }
                
            case .SearchPassword:
                EmptyView()
                //                회원가입 섹션
            case .Agreement:
                if let manager = appManager {
                    AgreementView(appManager: manager)
                }else{
                    ErrorView()
                }
            case .IdCreate:
                if let manager = signUpManager{
                    SignupIdView()
                        .environmentObject(manager)
                }else{
                    ErrorView()
                }
            case .PasswordCreate:
                if let manager = signUpManager{
                    SignupPasswordView()
                        .environmentObject(manager)
                }else{
                    ErrorView()
                }
            case .DobCreate:
                if let manager = signUpManager{
                    SignupDobView()
                        .environmentObject(manager)
                }else{
                    ErrorView()
                }
            case .PhoneCreate:
                if let manager = signUpManager{
                    SignUpMobileView()
                        .environmentObject(manager)
                }else{
                    ErrorView()
                }
            
            case .SignUpFinal:
                if let pageStatus = pageStatus, let name = name{
                    SignupFinalView(pageStatus:pageStatus,name: name)
                }else{
                    ErrorView()
                }
                //                체팅 관련
            case .advice:
                if let appManager = appManager, let hospitalId = hospitalId, let HospitalName = HospitalName{
                    ChatView(appManager: appManager, hospitalId: hospitalId, HospitalName: HospitalName)
                }else{
                    ErrorView()
                }
            }
            
            
        }
    }
}
