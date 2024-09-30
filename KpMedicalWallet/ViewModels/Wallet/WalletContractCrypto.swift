//
//  WalletContractCrypto.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/30/24.
//

import Foundation
import BigInt

class WalletContractCrypto: KPHWalletContract{
    
    
    func ReturningUnDecodArray(dic: [String:Any]) -> (success: Bool, contractResult: getShaerFromSmartContract?){
        do{
            let smartContract = try getShaerFromSmartContract(from: dic)
            print("✅contract parse success")
            
            return (true, smartContract)
        }catch{
            print("ReturningUnDecodArray \(error)")
            return (false, nil)
        }
    }
    
    func getSymetricKeys(array: getShaerFromSmartContract) -> (success: Bool, contractResult: [ShareStructForm]?){
        var returnItem: [ShareStructForm] = []
        guard let privatKey = getPrivateKeyFromKeyChain(account: UserAccount) else{
            return (false,nil)
        }
        for item in array.items{
            //            대칭키 복호화 후 새로운 배열 리턴
            let symetricKey = prkeyDecoding(privateKey: privatKey, encodeKey: item.patient_key)
            if symetricKey.success{
                print("✅decode Key success")
                print("decode key value : \(symetricKey.decodeKey)")
                returnItem.append(ShareStructForm(index: item.index, patient_key: symetricKey.decodeKey))
                
            }else{
                print("❌시메트릭키 뽑아오기 실패")
                //                print("Undecode key value : \(item.patientKey)")
            }
        }
        return (true, returnItem)
    }
    func CryptoSecKey(pubkey: String,decodeString:String) -> String{
        print("✅ pubkey")
        print(pubkey)
        print("✅ CRYPTOSTRING")
        print(decodeString)
        let der = Data(base64Encoded: pubkey, options: .ignoreUnknownCharacters)!
        let attributes: [String: Any] = [
            String(kSecAttrKeyType): kSecAttrKeyTypeRSA,
            String(kSecAttrKeyClass): kSecAttrKeyClassPublic,
            String(kSecAttrKeySizeInBits): der.count * 8
        ]
        let key = SecKeyCreateWithData(der as CFData, attributes as CFDictionary, nil)!
        // An example message to encrypt
        let plainText = decodeString.data(using: .utf8)!
        
        //        되는거
        let PK = SecKeyCreateEncryptedData(key, .rsaEncryptionPKCS1, plainText as CFData, nil)! as Data
        let asdfg = PK.base64EncodedString()
        return asdfg
        
    }
}
