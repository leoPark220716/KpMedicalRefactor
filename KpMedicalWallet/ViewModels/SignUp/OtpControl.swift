//
//  OtpControl.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/12/24.
//

import Foundation
import Combine

class OtpControl: SignUpDataModel,OtpCheck{
    
    @Published var otpCheck: Bool = true
    @Published var otpPermissionCheck: Bool = false
    @Published var verifyToken: String = ""
    @Published var otpViewShow: Bool = false
    @Published var timeRemaining: Int = 60
    @Published var toast: normal_Toast?
    @Published var otpCloseView: Bool = false
    private var timerSubscription: AnyCancellable?
    
    
    override init(router: NavigationRouter,errorHandler: GlobalErrorHandler) {
        super.init(router: router, errorHandler: errorHandler)
    }
    @MainActor
    func showOtpView(token: String){
        verifyToken = token
        otpViewShow = true
        startTimer()
    }
    
    @MainActor
    func OtpStatusTrue(){
        otpCheck = true
    }
    @MainActor
    func OtpStatusFalse(){
        otpCheck = false
    }
    
    @MainActor
    func timeReset(){
        self.timerSubscription?.cancel()
        timeRemaining = 60
    }
    
    private func startTimer() {
        timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timerSubscription?.cancel()
                }
            }
    }
    @MainActor
    func OtpNumberLimit(){
        if otp.count > 6 {
            otp = String(otp.prefix(6))
        }
    }
    
    @MainActor
    func finalRequestForLastView(check: Bool){
        otpCloseView = true
        router.push(to: .userPage(item: UserPage(page: .SignUpFinal), pageStatus: check ,name: name))
    }
    
    func SignUpOtpCheckButton(){
        Task{
            do{
                let otpRequest = try await checkOtpNumber()
                if !otpRequest{
                    return
                }
                let signupRequest = try await requestSignUp()
                if !signupRequest{
                    await finalRequestForLastView(check: false)
                    return
                }
                await finalRequestForLastView(check: true)
            }catch let error as TraceUserError {
                await errorHandler.displayError(ServiceError: error)
            }catch{
                await errorHandler.displayError(ServiceError: .unowned("감지 못한 에러 \(error.localizedDescription)"))
            }
            
        }
    }
    
    // otp 검증 요청
    private func checkOtpNumber() async throws -> (Bool){
        do{
            let request = createHttpStruct()
            let call = KPWalletAPIManager.init(httpStructs: request, URLLocations: 1)
            let response = try await call.performRequest()
            if response.success{
                return true
            }else{
                await OtpStatusFalse()
                return false
            }
        }catch{
            throw error
        }
    }
    private func createHttpStruct() -> http<Empty?, KPApiStructFrom<OtpResponse>>{
        return http<Empty?,KPApiStructFrom<OtpResponse>>(
            method: "GET",
            urlParse: "mobile/check?mobile=\(phone)&mobile_code=\(otp)",
            token: "",
            UUID: UserVariable.GET_UUID(),
            verify_token: verifyToken
        )
    }
    
    //    회원가입 요청
    private func requestSignUp() async throws -> Bool{
        do{
            let requestBody = try createSignUpRequestData()
            let request = creqteSignUpHttpStruct(body: requestBody)
            let call = KPWalletAPIManager.init(httpStructs: request, URLLocations: 1)
            let response = try await call.performRequest()
            if response.success{
                if response.data?.status == 202{
                    await handleVersionCheckFailure()
                    return true
                }
                else if response.data?.status == 201{
                    return true
                }
                throw TraceUserError.unowned("\(PlistManager.shared.string(forKey: "SignUp_request_unkownError")) \(response)")
            }
            throw TraceUserError.unowned("\(PlistManager.shared.string(forKey: "SignUp_request_unkownError")) \(response)")
            
        }catch{
            throw error
        }
        
    }
    private func creqteSignUpHttpStruct(body: SingupRequestModul) -> http<SingupRequestModul?, KPApiStructFromDataInt>{
        return http<SingupRequestModul?,KPApiStructFromDataInt>(
            method: "POST",
            urlParse: "users",
            token: "",
            UUID: UserVariable.GET_UUID(),
            requestVal: body
        )
    }
    private func createSignUpRequestData() throws -> SingupRequestModul {
        if phone == "" && account == "" && password == "" && name == "" && dob == "" && sex == "" && otp == ""{
            throw TraceUserError.clientError(PlistManager.shared.string(forKey: "SignUp_request_make_body"))
        }
        return SingupRequestModul(account: account, password: password, mobile: phone, name: name, dob: dob, sex_code: sex)
    }
    
    
    // 회원가입 아이디 중복으로인해 실패 사용자 알림 Toast Message
    private func handleVersionCheckFailure() async {
        print("✅ 앱 버전 체크 \(UserVariable.APP_VERSION())")
        await MainActor.run {
            toast = normal_Toast(message: PlistManager.shared.string(forKey: "signup_otp_singup_error_202"))
        }
    }
}
