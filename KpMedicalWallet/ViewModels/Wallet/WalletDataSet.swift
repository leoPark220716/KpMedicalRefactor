//
//  WalletDataSet.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/23/24.
//

import Foundation
import CryptoSwift
import web3swift
import Web3Core
import Security
import CryptoKit
import BigInt

class WalletDataSet: RSAKeyManager, ObservableObject{
    @Published var walletState: Bool = false
    @Published var isLoading: Bool = false
    @Published var Mnemonicse = ""
    @Published var mnemonicArray: [String] = []
    @Published var PublicKey: String = ""
    @Published var Contract: String = ""
    @Published var TrasactionList: [WalletModel.AccessItem] = []
    
    var password: String = ""
    var keystoreData: Data?
    var keystore: BIP32Keystore?
    var web3: Web3?
    var abi: String?
    var sol: String?
    var accountAddress: EthereumAddress?
    var UserAccount: String = ""
    let ChainID = BigUInt(142537)
    var token: String = ""
    
    
    //    초기 지갑 유무 확인 지갑 이 존재한다 = keystore 가 저장돼 있다. 를 의미하고
    func setDatas(appManager: NavigationRouter) async {
        
            print("Call setDatas")
            do{
                let account = appManager.GetUserAccountString()
                if !account.status{
                    throw TraceUserError.clientError("")
                }else{
                    UserAccount = account.account
                }
                if appManager.jwtToken == "" {
                    throw TraceUserError.clientError("")
                }
                token = appManager.jwtToken
                
                guard let _ = loadFromKeychain(account: UserAccount) else{
                    print("Call GuardLet")
                    await MainActor.run {
                        walletState = false
                        isLoading = false
                        print(isLoading)
                    }
                    return
                }
                
                await MainActor.run {
                    isLoading = false
                    walletState = true
                }
                
                
            }catch let error as TraceUserError{
                await appManager.displayError(ServiceError: error)
            }catch{
                await appManager.displayError(ServiceError: .unowned(error.localizedDescription))
            }
        
        
    }
    func setUpWeb3Datas() async throws {
        guard let url = URL(string: try UtilityURLReturn.BLOCKCHAIN_SERVER()) else{
            throw TraceUserError.clientError("")
        }
        guard let keystoreData = loadFromKeychain(account: UserAccount) else{
            throw TraceUserError.clientError("")
        }
        guard let keystore = BIP32Keystore(keystoreData) else{
            throw TraceUserError.clientError("")
        }
        let keystoreManager = KeystoreManager([keystore])
        let provider = try await Web3HttpProvider(url: url, network: .Custom(networkID: ChainID), keystoreManager: keystoreManager)
        guard let abiUrl = Bundle.main.url(forResource: "PersonalRecords_sol_PersonalRecords", withExtension: "json"),
              let abiString = try? String(contentsOf: abiUrl) else {
            throw TraceUserError.clientError("")
        }
        guard let bytecodeUrl = Bundle.main.url(forResource: "PersonalRecords_sol_PersonalRecords", withExtension: "bin"),
              let bytecodeString = try? "0x"+String(contentsOf: bytecodeUrl) else {
            throw TraceUserError.clientError("")
        }
        guard let accountAddress = keystore.addresses?.first else {
            throw TraceUserError.clientError("")
        }
        self.keystoreData = keystoreData
        self.keystore = keystore
        self.web3 = Web3(provider: provider)
        self.abi = abiString
        self.sol = bytecodeString
        self.accountAddress = accountAddress
    }
    func returnWeb3Datas() throws -> Bool {
        guard keystore != nil else {
            throw TraceUserError.clientError("Keystore is nil")
        }
        guard keystoreData != nil else {
            throw TraceUserError.clientError("KeystoreData is nil")
        }
        guard web3 != nil else {
            throw TraceUserError.clientError("Web3 is nil")
        }
        guard abi != nil else {
            throw TraceUserError.clientError("ABI is nil")
        }
        guard sol != nil else {
            throw TraceUserError.clientError("Sol is nil")
        }
        guard accountAddress != nil else {
            throw TraceUserError.clientError("AccountAddress is nil")
        }
        
        return true
    }
    
    // nonce 및 gas
    func returnGasNonce() async throws -> (gas: BigUInt, nonce: BigUInt) {
        let maxGasPrice = BigUInt(50) * BigUInt(10).power(9) // 예: 50 Gwei
        guard let gasPrice = try await web3?.eth.gasPrice() else {
            throw TraceUserError.clientError("")
        }
        guard gasPrice <= maxGasPrice else {
            throw TraceUserError.clientError("")
        }
        guard let account = accountAddress else {
            throw TraceUserError.clientError("")
        }
        guard let currentNonce = try await web3?.eth.getTransactionCount(for: account, onBlock: .latest) else {
            throw TraceUserError.clientError("")
        }
        let increasedGasPrice = gasPrice * 120 / 100
        return (gas: increasedGasPrice, nonce: currentNonce)
    }
    // 니모닉 문구 생성
    func generateMnmonics() throws{
        Task{
            do {
                guard let newMnemonics = try BIP39.generateMnemonics(bitsOfEntropy: 128, language: .english) else {
                    throw TraceUserError.clientError("")
                }
                await MainActor.run {
                    Mnemonicse = newMnemonics
                    mnemonicArray = newMnemonics.components(separatedBy: " ")
                }
            } catch {
                throw error
            }
        }
    }
    
    @MainActor
    func setTrasactionList(list: [WalletModel.AccessItem]){
        self.TrasactionList.append(contentsOf: list)
    }
}
