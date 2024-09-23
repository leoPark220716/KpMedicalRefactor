//
//  NavigationRouter.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation
import SwiftUI

final class NavigationRouter: UserInfomationManager {
    @Published var routes = [Route]()
    @Published var RootView: DefaultPage = .splash
    @Published var TabViewSelection: TabViewTabs = .home
    @Published var toast: normal_Toast?
    
    //    탭 뷰에 객체 관리
    @Published var myHospitalView: HospitalListMainViewModel?
    
    // TabView NavigationTitle
    var TitleString: String {
        switch TabViewSelection{
        case .home:
            return "안녕하세요 \(name)님!"
        case .hospital:
            return "내 병원"
        case .account:
            return "내 계정"
        }
    }
    
    //    자동로그인 후 라우터 설정
    func RouteViewByAutoLogin(){
        Task{
            do{
                let rootview = try await super.checkAutoLogin()
                await rootView(change: rootview)
            }catch let error as TraceUserError {
                Authdel()
                await displayError(ServiceError: error)
            }catch{
                Authdel()
                await displayError(ServiceError: .unowned(PlistManager.shared.string(forKey: "UserInfomation_returnUserData")))
            }
            
        }
    }
    @MainActor
    func push(to: Route){
        routes.append(to)
    }
    
    @MainActor
    func rootView(change: DefaultPage){
        RootView = change
    }
    @MainActor
    func goToRootView(){
        routes = []
    }
    @MainActor
    func goBack(){
        _ = routes.popLast()
    }
    
    @MainActor
    func myHospitalViewInit() {
        if myHospitalView == nil {
            myHospitalView = HospitalListMainViewModel()
        }
    }
    
    
    func myHospitalViewDeInit(){
        myHospitalView = nil
    }
    
    @MainActor
    override func logOut() async {
        await super.logOut()
        goToRootView()
        TabViewSelection = .home
        RootView = .splash
    }
}
