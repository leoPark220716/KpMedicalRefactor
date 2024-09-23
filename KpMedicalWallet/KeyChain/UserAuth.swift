//
//  UserAuth.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation


struct AuthData {
    func userAuthSave(userData: UserData) throws -> OSStatus {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(userData)
            
            let query: [String: Any] = [
                kSecClass as String: kSecClassInternetPassword,
                kSecAttrServer as String: try UtilityURLReturn.API_SERVER(),
                kSecAttrAccount as String: try UserVariable.FOR_USER_AUTH(),
                kSecValueData as String: data
            ]
            
            // 동일한 서비스와 계정에 대한 아이템 제거 중복저장 방지.
            SecItemDelete(query as CFDictionary)
            // 새로운 Keychain 추가.
            return SecItemAdd(query as CFDictionary, nil)
        }catch {
            throw TraceUserError.configError("\(PlistManager.shared.string(forKey: "authData")) \(error)")
        }
    }
    
    func userLoadAuthData() throws -> UserData? {
        do{
            let query: [String: Any] = [
                kSecClass as String: kSecClassInternetPassword,
                kSecAttrServer as String: try UtilityURLReturn.API_SERVER(),
                kSecAttrAccount as String: try UserVariable.FOR_USER_AUTH(),
                kSecReturnData as String: kCFBooleanTrue!,
                kSecMatchLimit as String: kSecMatchLimitOne
            ]
            var dataTypeRef: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
            if status == errSecSuccess, let data = dataTypeRef as? Data {
                let decoder = JSONDecoder()
                let userData = try decoder.decode(UserData.self, from: data)
                return userData
            }else{
                return nil
            }
        }
        catch {
            throw TraceUserError.configError("\(PlistManager.shared.string(forKey: "userLoadAuthData")) \(error)")
        }
    }
    
    func deleteAllKeyChainItems(){
        let secItemClasses = [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity]
        for secItemClass in secItemClasses {
            let dictionary = [kSecClass as String: secItemClass]
            let status = SecItemDelete(dictionary as CFDictionary)
            
            switch status {
            case errSecSuccess:
                print("\(secItemClass) items deleted successfully.")
            case errSecItemNotFound:
                print("No items were found to delete for \(secItemClass).")
            default:
                print("An error occurred while deleting items for \(secItemClass): \(status)")
            }
        }
    }
    
    //    Otp 비밀번호 저장
    func savePassword(password: String, account: String) -> Bool{
        guard let passwordData = password.data(using: .utf8) else{
            print("passward Data 변환 실패")
            return false
        }
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "knp.kpmadical_wallet.com.OPTPass_\(account)",
            kSecValueData as String: passwordData
        ]
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    //    Otp 비밀번호 검증
    func verifyPassword(password: String, account: String) -> Bool{
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "knp.kpmadical_wallet.com.OPTPass_\(account)",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let passwordData = item as? Data, let savedPassword = String(data: passwordData, encoding: .utf8) else {
            return false
        }
        return password == savedPassword
    }
    //    Otp 비밀번호 키체인 있는지 조회
    func checkPasswordExists(account: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "knp.kpmadical_wallet.com.OPTPass_\(account)",
            kSecReturnData as String: kCFBooleanFalse!, // 데이터 반환하지 않음
            kSecMatchLimit as String: kSecMatchLimitOne // 최대 하나의 결과만 매칭
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }
}

