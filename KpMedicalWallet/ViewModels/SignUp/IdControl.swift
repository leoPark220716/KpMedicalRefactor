import Foundation
import SwiftUI

class IdControl: DobControl,UserAccountHandle{
    
    @Published var idCheck: Bool = false
    @Published var IdFieldStatus: Bool = true
    @Published var permissionCheck: Bool = false
    
    override init(router: NavigationRouter) {
        super.init(router: router)
    }
    //    유저 가이드라인
    // 포맷 검사 및 아이디 변경 감지
    @MainActor
    func detechIdFild(text: String) {
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,30}$"
        let isMatchingRegex = NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: text)
        
        IdFieldStatus = isMatchingRegex
        idCheck = false
        permissionCheck = false
    }
    // 아이디 필드 값이 없다면 원래대로 돌려놓음
    @MainActor
    func IdresetStatus(text: String){
        if text == "" {
            IdFieldStatus = true
        }
    }
    
    func SignUpIdActonCheckButton() {
        Task{
            do{
                try await idCheckRequest()
            }catch let error as TraceUserError {
                await appManager.displayError(ServiceError: error)
            }catch{
                await appManager.displayError(ServiceError: .unowned("감지 못한 에러 \(error.localizedDescription)"))
            }
        }
    }
    // 회원가입 유저 이동
    @MainActor
    func movePasswordView(){
        appManager.push(to: .userPage(item: UserPage(page: .PasswordCreate), signUpManager: self))
    }
    @MainActor
    func moveDobView(){
        appManager.push(to: .userPage(item: UserPage(page: .DobCreate), signUpManager: self))
    }
    @MainActor
    func movePhonView(){
        appManager.push(to: .userPage(item: UserPage(page: .PhoneCreate), signUpManager: self))
    }
    
    
    
    @MainActor
    func goBackLoginView(){
        appManager.goToRootView()
    }
    @MainActor
    private func makeIdCheckTrue(account: String){
        self.account = account
        idCheck = true
        permissionCheck = true
    }
    
    @MainActor
    private func makeIdCheckfalse(){
        idCheck = true
        permissionCheck = false
    }
    
    private func idCheckRequest() async throws {
        do{
            let request = createHttpStruct()
            let call = KPWalletAPIManager.init(httpStructs: request, URLLocations: 1)
            let response = try await call.performRequest()
            if response.data?.status == 200 {
                guard let account = response.data?.data.account else{
                    throw TraceUserError.serverError(PlistManager.shared.string(forKey: "SingUp_idCheckRequest"))
                }
                await makeIdCheckTrue(account: account)
                return
            }else{
                await makeIdCheckfalse()
            }
        }catch{
            throw error
        }
    }
    
    // 요청 및 응답 객체 생성
    private func createHttpStruct() -> http<Empty?,KPApiStructFrom<IDCheckResponse>>{
        return http<Empty?,KPApiStructFrom<IDCheckResponse>>(
            method: "GET",
            urlParse: "users/\(account)/check",
            token: "",
            UUID: UserVariable.GET_UUID()
        )
    }
    
}
