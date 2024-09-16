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
}

