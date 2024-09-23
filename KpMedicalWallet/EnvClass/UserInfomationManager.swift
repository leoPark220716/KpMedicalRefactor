//
//  UserInfomationManager.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation
import Firebase

class UserInfomationManager: GlobalErrorHandler,UserManager,HaveJWT,HaveFCMToken{
    @Published var name: String = ""
    @Published var dob: String = ""
    @Published var sex: String = ""
    @Published var jwtToken: String = ""
    var fcmToken: String = ""
    var loginStatus: Bool = false
    
    @MainActor
    func SetInfo(datas: UserData){
        name = datas.name
        dob = datas.dob
        sex = datas.sex
        jwtToken = datas.jwtToken
    }
    
    @MainActor
    func setDefautl(){
        name = ""
        dob = ""
        sex = ""
        jwtToken = ""
        fcmToken = ""
        loginStatus = false
    }
    func logOut() async {
            Authdel()
            await setDefautl()
    }
    func Authdel(){
        let auth = AuthData()
        auth.deleteAllKeyChainItems()
    }
    
    private func retrunUserData() throws -> UserData?{
        let auth = AuthData()
        guard let userData = try auth.userLoadAuthData() else {
            return nil
        }
        return userData
    }
    
    func checkAutoLogin() async throws -> DefaultPage{
        do{
            let userData = try retrunUserData()
            guard let datas = userData else{
                return DefaultPage .login
            }
            return try await AutoLoginRequest(jwtToken: datas.jwtToken)
        }catch {
            throw error
        }
    }
    
    //    자동 로그인 코드
    private func AutoLoginRequest(jwtToken: String) async throws -> DefaultPage {
        do{
            let request = createAutoLoginHttpStruct(jwtToken: jwtToken)
            let call = KPWalletAPIManager.init(httpStructs: request, URLLocations: 1)
            let response = try await call.performRequest()
            if response.success, let data = response.data?.data {
                await SetInfo(datas: UserData.init(name: data.name, dob: data.dob, sex: data.sex_code, jwtToken: data.access_token))
                return DefaultPage .tab
            }
            return DefaultPage .login
        }catch{
            throw error
        }
    }
    
    private func createAutoLoginHttpStruct(jwtToken: String) -> http<Empty?,KPApiStructFrom<AutoLoginModel>>{
        return http<Empty?,KPApiStructFrom<AutoLoginModel>>(
            method: "GET",
            urlParse: "v2/users/access/auto",
            token: jwtToken,
            UUID: UserVariable.GET_UUID()
        )
    }
    
    
    
    
    //    유저 Account 추출
    func GetUserAccountString() -> (status: Bool, account: String) {
        print("✅GetUserAccountString \(jwtToken)")
        let sections = jwtToken.components(separatedBy: ".")
        if sections.count > 2 {
            var base64String = sections[1]
            
            // Base64 URL-safe 인코딩을 일반 Base64로 변환
            base64String = base64String.replacingOccurrences(of: "-", with: "+")
            base64String = base64String.replacingOccurrences(of: "_", with: "/")
            
            // 패딩 추가
            while base64String.count % 4 != 0 {
                base64String.append("=")
            }
            
            if let payloadData = Data(base64Encoded: base64String, options: .init()),
               let payloadJSON = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any],
               let userId = payloadJSON["user_id"] as? String {
                // user_id 값 출력
                return (true, userId)
            } else {
                print("Payload decoding or JSON parsing failed")
                return (false, "")
            }
        } else {
            print("Invalid JWT Token")
            return (false, "")
        }
    }
    
    
    //    FCM Token 발급
    func refreshFCMToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("❌Error fetching FCM token: \(error)")
            } else if let token = token {
                print("✅New FCM token: \(token)")
                self.fcmToken = token
            }
        }
    }
    //    FCM Token 삭제
    func deleteFCMToken(){
        Messaging.messaging().deleteToken { error in
            print("❌FCMToken delete Error \(String(describing: error))")
        }
        print("✅FCM Token DeleteToken Method Call")
    }
    
    // 자동 로그인
}
