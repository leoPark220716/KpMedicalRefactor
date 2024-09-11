//
//  UserInfomationManager.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation
import Firebase

class UserInfomationManager: UserManager,ObservableObject{
    @Published var name: String = ""
    @Published var dob: String = ""
    @Published var sex: String = ""
    @Published var token: String = ""
    var fcmToken: String = ""
    var loginStatus: Bool = false
    
    @MainActor
    func SetInfo(datas: LoginResponse){
        name = datas.name
        dob = datas.dob
        sex = datas.sex_code
        token = datas.access_token
    }
    
    @MainActor
    func Logout(){
        name = ""
        dob = ""
        sex = ""
        token = ""
        fcmToken = ""
        loginStatus = false
    }
    init() {
        do{
            let auth = AuthData()
            guard let userData = try auth.userLoadAuthData() else {
                return
            }
            name = userData.name
            dob = userData.dob
            sex = userData.sex
            token = userData.token
        }catch{
            
        }
    }
    
//    유저 Account 추출
    func GetUserAccountString() -> (status: Bool, account: String) {
        print("✅GetUserAccountString \(token)")
        let sections = token.components(separatedBy: ".")
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
}
