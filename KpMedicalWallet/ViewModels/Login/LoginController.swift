//
//  LoginController.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation

class LoginController: LoginModel, LoginRequest {
    
    private var router: NavigationRouter
    
    init(router: NavigationRouter) {
        self.router = router
    }
    
    func LoginCheck() async -> (error: Bool, token: LoginResponse?){
        //        요청 구조체 객체 생성
        let requestData: LoginModul = .init(account: id, password: password, uid: UserVariable.GET_UUID())
        let request = http<LoginModul?,KPApiStructFrom<LoginResponse>>.init(
            method: "POST",
            urlParse: "users/access",
            token: "",
            UUID: requestData.uid,
            requestVal: requestData
        )
        // 숫자로 URL 파싱 1 일 경우 wallet Api 호출
        let call = KPWalletAPIManager.init(httpStructs: request, URLLocations: 1)
        let response = await call.performRequest()
        await MainActor.run {
            checked = response.success
            if !checked {
                toast = normal_Toast(message: "아이디 또는 비밀번호가 올바르지 않습니다.")
            }
        }
        return (error: response.success, token: response.data?.data)
    }
    
    func actionLoginAction(){
        Task{
            let result = await LoginCheck()
            if result.error{
                guard let data = result.token else {
                    return
                }
                await router.SetInfo(datas: data)
                await router.rootView(change: .tab)
                router.refreshFCMToken()
            }
        }
    }
    func actionSignUpAction(){
        
    }
    func searchPasswordAction(){
        
    }
    
}
