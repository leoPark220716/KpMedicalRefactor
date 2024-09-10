//
//  UserAuth.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation

struct UserData: Codable, UserManager {
    
    var name: String
    var dob: String
    var sex: String
    var token: String
    var fcmToken: String
    
}

struct AuthData {
    
    func saveToKeyChain(userData: UserData) -> OSStatus {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(userData)
            
            let query: [String: Any] = [
                kSecClass as String: kSecClassInternetPassword,
                kSecAttrServer as String: UtilityURLReturn.API_SERVER(),
                kSecAttrAccount as String: UserVariable.FOR_USER_AUTH(),
                kSecValueData as String: data
            ]
            
            // 동일한 서비스와 계정에 대한 아이템 제거 중복저장 방지.
            SecItemDelete(query as CFDictionary)
            // 새로운 Keychain 추가.
            return SecItemAdd(query as CFDictionary, nil)
        } catch {
            print("Failed to encode user data: \(error)")
            return errSecDecode
        }
    }
    
    func loadFromKeyChain() -> UserData? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: UtilityURLReturn.API_SERVER(),
            kSecAttrAccount as String: UserVariable.FOR_USER_AUTH(),
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            do {
                let decoder = JSONDecoder()
                let userData = try decoder.decode(UserData.self, from: data)
                return userData
            } catch {
                print("Failed to decode user data: \(error)")
            }
        }
        return nil
    }
}

