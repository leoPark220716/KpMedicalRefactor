//
//  WalletKeyStoreKeyChain.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/23/24.
//

import Foundation

class WalletKeyStoreKeyChain{
    func saveToKeyChain(keystoreData: Data, account: String) ->OSStatus {
        let query: [String:Any] = [
            //            저장하는 아이템 타입 정의
            kSecClass as String: kSecClassGenericPassword,
            //            서비스 식별 문자열 정의
            kSecAttrService as String: PlistManager.shared.string(forKey: "KeyChainWalletService"),
            //            계정 식별 문자열 정의
            kSecAttrAccount as String: "knp.kpmadical_wallet.com.Wallet_Keystore_\(account)",
            //            실제 저장하는 데이터 정의
            kSecValueData as String: keystoreData
        ]
        //        동일한 서비스와 계정에 대한 아이템 제거 중복저장 방지.
        SecItemDelete(query as CFDictionary)
        //        새로운 Keychain 추가.
        return SecItemAdd(query as CFDictionary, nil)
    }
    //    키체인에 저장된 keystore 가져오기
    func loadFromKeychain(account: String) ->Data?{
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: PlistManager.shared.string(forKey: "KeyChainWalletService"),
            kSecAttrAccount as String: "knp.kpmadical_wallet.com.Wallet_Keystore_\(account)",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: AnyObject?
        //        쿼리에 해당하는 아이템 검색, 검색에 성공하면 item 변수에 저장되고 errSecSuccess 반환.
        let status = SecItemCopyMatching(query as CFDictionary,&item)
        guard status == errSecSuccess else{
            print("오브젝트 생성 실패")
            return nil
        }
        return item as? Data
    }
    //    키체인에 keystore 비밀번호 저장
    func saveKeystorePassword(password: String, account: String) -> Bool{
        guard let passwordData = password.data(using: .utf8) else{
            print("passward Data 변환 실패")
            return false
        }
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "knp.kpmadical_wallet.com.Wallet_Keystore_Password_\(account)",
            kSecValueData as String: passwordData
        ]
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    //     키체인 키스토어 비밀번호 가져오기
    func GetPasswordKeystore(account: String) -> (seccess: Bool, password: String) {
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "knp.kpmadical_wallet.com.Wallet_Keystore_Password_\(account)",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let passwordData = item as? Data, let savedPassword = String(data: passwordData, encoding: .utf8) else {
                return (false, "")
            }
        return (true, savedPassword)
    }

}
