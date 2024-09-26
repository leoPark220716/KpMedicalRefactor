//
//  KPHWallet.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/23/24.
//

import Foundation
import UIKit



class KPHWallet : KPHWalletContract{
    
    @MainActor
    func goToCreatePasswordView(appManager: NavigationRouter){
        appManager.push(to: .userPage(item: UserPage(page: .walletPassword), appManager: appManager, walletModel: self))
    }
    @MainActor
    func goToCreateMnemonicView(appManager: NavigationRouter){
        appManager.push(to: .userPage(item: UserPage(page: .walletMnemonic), walletModel: self))
    }
    @MainActor
    func goToRecoverWalletView(appManager: NavigationRouter){
        appManager.push(to: .userPage(item: UserPage(page: .walletRecover), appManager: appManager, walletModel: self))
    }
    // 지갑 생성
    func OnTapCreateWalletButton(appManager: NavigationRouter) async -> (Bool) {
        
        do{
            let walletKeys = try generateWallet()
            let saveKeyStorePassword = saveKeystorePassword(password: password, account: UserAccount)
            if !saveKeyStorePassword{
                print("❌ saveKeyStorePassword ")
                await appManager.displayError(ServiceError: .clientError(""))
                return false
            }
            let RSAKey = try generateRSAKeyPair(account: UserAccount)
            if !RSAKey.success{
                print("❌ RSAKey ")
                await appManager.displayError(ServiceError: .clientError(""))
                return false
            }
            let StringRSAKeys = getStringRSAPrivateKey(account: UserAccount)
            if !StringRSAKeys.success{
                print("❌ StringRSAKeys ")
                await appManager.displayError(ServiceError: .clientError(""))
                return false
            }
            print("✅ \(StringRSAKeys.publickey)")
            print("✅ \(StringRSAKeys.privateKey)")
            // 지갑 개인키로 RSA 개인키 암호화
            let RSASecKey = try RSAPrivateKeyCrypto(privateKey: walletKeys.privateKey, RSAprivatKey: StringRSAKeys.privateKey)
            if !RSASecKey.success{
                print("❌ RSASecKey ")
                await appManager.displayError(ServiceError: .clientError(""))
                return false
            }
            try await setUpWeb3Datas()
            print("✅ 암호화된 RSA KEY \(RSASecKey.rsaSecPrivateKey)")
            try await saveWalletAddress(address: walletKeys.WalletPublicKey, encrypt_rsa: RSASecKey.rsaSecPrivateKey)
            let contract = try await  SmartContractDeploy(contractPara: StringRSAKeys.publickey)
            if !contract.success{
                print("❌ contract ")
                await appManager.displayError(ServiceError: .clientError(""))
                return false
            }
            try await saveContractAddress(contract: contract.ContractAddress)
            return true
        }catch let error as TraceUserError{
            await appManager.displayError(ServiceError: error)
            return false
        }catch{
            await appManager.displayError(ServiceError: .unowned(error.localizedDescription))
            return false
        }
    }
    // 지갑 복구
    func OnTabRecoverWalletButton(appManager: NavigationRouter,password: String){
        Task{
            do{
                let recoverAddress = try recoverWallet(password: password)
                let saveWalletPassword = saveKeystorePassword(password: password, account: UserAccount)
                if !saveWalletPassword{
                    print("❌Save Wallet Password False")
                    await appManager.displayError(ServiceError: .clientError(""))
                }
                let encryptRsa = try await getRSAencryptKey(address: recoverAddress)
                let recoverRsa = try recoverRSAPrivateKey(account:UserAccount, encodeString: encryptRsa, password: password)
                let saveDecodeRsa = try savePrivateKeyToKeyChain(privateKeyString: recoverRsa.RSAPrivate, account: UserAccount)
                if saveDecodeRsa{
                    await appManager.goBack()
                }
            }catch let error as TraceUserError{
                await appManager.displayError(ServiceError: error)
            }catch{
                await appManager.displayError(ServiceError: .unowned(error.localizedDescription))
            }
            
        }
    }
    
}
