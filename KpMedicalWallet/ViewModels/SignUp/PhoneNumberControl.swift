//
//  PhoneNumberControl.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/12/24.
//

import Foundation

class PhoneNumberControl:OtpControl, PhonNumberCheck{
    @Published var numberCheck: Bool = true
    @Published var NumberPermissionCheck: Bool = false
    
    override init(router: NavigationRouter) {
        super.init(router: router)
    }
    
    @MainActor
    func LinmitPhoneNumber(){
        if phone.count > 11 {
            phone = String(phone.prefix(11))
        }
    }
    
    // 휴대폰 번호 검증
    @MainActor
    func MobileNumberCheck(){
        if phone == "" {
            numberCheck = true
            return
        }
        else if phone.count == 11 {
            NumberPermissionCheck = true
            numberCheck = true
            return
        }else{
            numberCheck = false
        }
    }
    
    func SignUpOtpActonCheckButton(){
        Task{
            do{
                try await getOtpNumberByMobile()
            }catch let error as TraceUserError {
                await appManager.displayError(ServiceError: error)
            }catch{
                await appManager.displayError(ServiceError: .unowned("감지 못한 에러 \(error.localizedDescription)"))
            }
        }
    }
    
    private func getOtpNumberByMobile() async throws {
        do{
            let request = createHttpStruct()
            let call = KPWalletAPIManager.init(httpStructs: request, URLLocations: 1)
            let response = try await call.performRequest()
            if response.data?.status == 200 {
                guard let temp_token = response.data?.data.verify_token else {
                    throw TraceUserError.serverError(PlistManager.shared.string(forKey: "SignUp_Verify_token_getotp"))
                }
                await showOtpView(token: temp_token)
                return
            }else{
                throw TraceUserError.serverError(PlistManager.shared.string(forKey: "SignUp_Verify_token_getotp"))
            }
        }catch{
            throw error
        }
    }
    
    private func createHttpStruct() -> http<Empty?, KPApiStructFrom<MobileResponse>>{
        return http<Empty?,KPApiStructFrom<MobileResponse>>(
            method: "GET",
            urlParse: "mobile?mobile=\(phone)",
            token: "",
            UUID: UserVariable.GET_UUID()
        )
    }
}
