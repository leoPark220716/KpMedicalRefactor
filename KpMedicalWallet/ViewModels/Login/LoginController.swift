//
//  LoginController.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation

// LoginRequest
class LoginController: LoginModel, LoginRequest {
    
    var appManager: NavigationRouter
    
    init(appManager: NavigationRouter) {
        self.appManager = appManager
    }
    // 로그인 버튼 동작 함수
    func actionLoginAction(){
        Task{
            do{
                // 로그인 함수 호출
                let result = try await LoginCheck()
                // 성공시
                if result.success{
                    // 데이터에 AccessToken 확인
                    guard let data = result.token else {
                        return
                    }
                    // 유저 KeyChain 에 해당 데이터 저장.
                    let status = try SaveUserData(name: data.name, dob: data.dob, sex: data.sex, token: data.jwtToken)
                    // 저장 성공시 KeyChain 에 저장
                    if status {
                        // Env 객체에 저장
                        await appManager.SetInfo(datas: data)
                        // Env 객체에 FCM 토큰 호출
                        appManager.refreshFCMToken()
                        try await appManager.fcmTokenToServer(method: "POST")
                        // 뷰 텝뷰로 전환
                        await appManager.rootView(change: .tab)
                    }
                }
            }catch let error as TraceUserError {
                await appManager.displayError(ServiceError: error)
            } catch {
                await appManager.displayError(ServiceError:  .unowned(error.localizedDescription))
            }
        }
    }
    @MainActor
    func CheckReturnTrue(){
        checked = true
    }
    
    //    회원가입 페이지 이동
    @MainActor
    func actionSignUpAction(){
        appManager.push(to: .userPage(item: UserPage(page: .Agreement), appManager: appManager))
    }
    
    func searchPasswordAction(){
        
    }
    private func SaveUserData(name: String, dob: String, sex: String, token: String) throws -> (Bool) {
        do{
            let authData = AuthData()
            let status = try authData.userAuthSave(userData: UserData(name: name, dob: dob, sex: sex, jwtToken: token))
            return status != errSecDecode
        }catch{
            throw error
        }
    }
    
    //    로그인 확인
    private func LoginCheck() async throws -> (success: Bool, token: UserData?, errorMessage: String?) {
        do{
            let requestData = createLoginRequestData()
            let request = createHttpRequest(with: requestData)
            let call = KPWalletAPIManager.init(httpStructs: request, URLLocations: 1)
            let response = try await call.performRequest()
            if response.success{
                if response.data?.status == 202 {
                    await handleVersionCheckFailure()
                    return (success: false, token: nil, errorMessage: response.ErrorMessage)
                } else {
                    await navigateToSplashScreen()
                    return (success: response.success, token: response.data?.data, errorMessage: nil)
                }
            }
            await handleVersionCheckFailure()
            return (success: false, token: nil, errorMessage: response.ErrorMessage)
        }catch{
            throw error
        }
    }
    //    LoginModul 생성 요청 객체
    private func createLoginRequestData() -> LoginModul {
        return LoginModul(account: id, password: password, uid: UserVariable.GET_UUID())
    }
    // 응답 및 요청 객체 생성
    private func createHttpRequest(with requestData: LoginModul) -> http<LoginModul?, KPApiStructFrom<UserData>> {
        return http<LoginModul?, KPApiStructFrom<UserData>>(
            method: "POST",
            urlParse: "users/access",
            token: "",
            UUID: requestData.uid,
            requestVal: requestData
        )
    }
    // 202 응답 시 로그인 실패 사용자 알림 Toast Message
    private func handleVersionCheckFailure() async {
        print("✅ 앱 버전 체크 \(UserVariable.APP_VERSION())")
        await MainActor.run {
            checked = false
            do {
                appManager.toast = normal_Toast(message: try UserVariable.TOAST_LOGIN_FAIL())
            } catch TraceUserError.configError(let errorDetail) {
                print(errorDetail)
            } catch {
                print(error)
            }
        }
    }
    // 로그인 성공시 SplashView 로 이동
    private func navigateToSplashScreen() async {
        await MainActor.run {
            appManager.rootView(change: .splash)
        }
    }
}
