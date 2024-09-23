//
//  KPHWallet.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/23/24.
//

import Foundation

class KPHWallet : KPHWalletContract{
 
    @MainActor
    func goToCreatePasswordView(appManager: NavigationRouter){
        appManager.push(to: .userPage(item: UserPage(page: .walletPassword), appManager: appManager, walletModel: self))
    }
    @MainActor
    func goToCreateMnemonicView(appManager: NavigationRouter){
        appManager.push(to: .userPage(item: UserPage(page: .walletMnemonic), walletModel: self))
    }
    
    
    func OnTapCreateWalletButton(appManager: NavigationRouter){
        Task{
            do{
                let walletKeys = try generateWallet()
                let saveKeyStorePassword = saveKeystorePassword(password: password, account: UserAccount)
                if !saveKeyStorePassword{
                    print("❌ saveKeyStorePassword ")
                    await appManager.displayError(ServiceError: .clientError(""))
                    return
                }
                let RSAKey = try generateRSAKeyPair(account: UserAccount)
                if !RSAKey.success{
                    print("❌ RSAKey ")
                    await appManager.displayError(ServiceError: .clientError(""))
                    return
                }
                let StringRSAKeys = getStringRSAPrivateKey(account: UserAccount)
                if !StringRSAKeys.success{
                    print("❌ StringRSAKeys ")
                    await appManager.displayError(ServiceError: .clientError(""))
                    return
                }
                print("✅ \(StringRSAKeys.publickey)")
                print("✅ \(StringRSAKeys.privateKey)")
                // 지갑 개인키로 RSA 개인키 암호화
                let RSASecKey = try RSAPrivateKeyCrypto(privateKey: walletKeys.privateKey, RSAprivatKey: StringRSAKeys.privateKey)
                if !RSASecKey.success{
                    print("❌ RSASecKey ")
                    await appManager.displayError(ServiceError: .clientError(""))
                    return
                }
                try await setUpWeb3Datas()
                print("✅ 암호화된 RSA KEY \(RSASecKey.rsaSecPrivateKey)")
                try await saveWalletAddress(address: walletKeys.WalletPublicKey, encrypt_rsa: RSASecKey.rsaSecPrivateKey)
                let contract = try await  SmartContractDeploy(contractPara: StringRSAKeys.publickey)
                if !contract.success{
                    print("❌ contract ")
                    await appManager.displayError(ServiceError: .clientError(""))
                    return
                }
                try await saveContractAddress(contract: contract.ContractAddress)
                await appManager.goToRootView()
                await appManager.push(to: .userPage(item: UserPage(page: .walletMain)))
                
            }catch let error as TraceUserError{
                await appManager.displayError(ServiceError: error)
            }catch{
                await appManager.displayError(ServiceError: .unowned(error.localizedDescription))
            }
        }
        
    }
}
