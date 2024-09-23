//
//  KPHWalletContract.swift
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
class KPHWalletContract: WalletHttpRequest{
    
    
    
    // 지갑 생성
    func generateWallet() throws -> (success: Bool,privateKey: String, WalletPublicKey: String) {
        guard !Mnemonicse.isEmpty else {
            print("니모닉 빈배열")
            throw TraceUserError.clientError("")
        }
        do {
            //            keystore 생성.
            guard let keystore = try BIP32Keystore(mnemonics: Mnemonicse, password: password) else {
                print("keystore 생성 실패")
                throw TraceUserError.clientError("")
            }
            // 새로운 계정을 생성합니다.
            try keystore.createNewChildAccount(password: password)
            //            keystore 직렬화
            guard let keystoreData = try keystore.serialize()else{
                print("직렬화 실패")
                throw TraceUserError.clientError("")
            }
            //            직렬화 keystore keychain 에 저장
            let saveStatus = saveToKeyChain(keystoreData: keystoreData, account: UserAccount)
            if saveStatus != errSecSuccess {
                print("직렬화??? \(saveStatus)")
                throw TraceUserError.clientError("")
            }
            // 첫 번째 주소를 가져옵니다.
            if let address = keystore.addresses?.first {
                let privateKeyData = try keystore.UNSAFE_getPrivateKeyData(password: password, account: address)
                let privateKeyHexString = privateKeyData.toHexString()
                self.keystore = keystore
                self.keystoreData = keystoreData
                if self.keystore == nil || self.keystoreData == nil{
                    print("❌ 지갑 생성 과정 데이터 객체 할당 실패")
                    throw TraceUserError.clientError("")
                }
                return (true,privateKeyHexString,address.address)
            } else {
                print("지갑 주소 가져오기 실패")
                throw TraceUserError.clientError("")
            }
        } catch {
            print("지갑생성 에러 \(error)")
            throw TraceUserError.clientError(error.localizedDescription)
        }
    }
    func SmartContractDeploy(contractPara: String) async throws -> (success: Bool, ContractAddress: String){
        do{
            let web3Datas = try returnWeb3Datas()
            if web3Datas{
                guard let bytecodeData = Data.fromHex(sol!) else {
                    print("바이트코드 문자열을 Data로 변환할 수 없습니다.")
                    return (false, "")
                }
                //            배포할 컨트랙트 객체 생성
                let contract = Web3.Contract(web3: web3!, abiString: abi!, at: accountAddress, abiVersion: 2)
                //             배포 옵션 설정
                let deployOption = contract?.prepareDeploy(bytecode: bytecodeData, constructor: contract?.contract.constructor, parameters: [contractPara])
                //            트랜잭션 설정
                let gas = try await returnGasNonce()
                print("공개키")
                print(accountAddress!.address)
                print("여기까지")
                deployOption?.transaction.nonce = gas.nonce
                deployOption?.transaction.chainID = ChainID
                deployOption?.transaction.to = .contractDeploymentAddress()
                deployOption?.transaction.from = accountAddress
                deployOption?.transaction.gasPrice = gas.gas
                if let result = try await deployOption?.writeToChain(password: password, sendRaw: true){
                    print("Transaction 전송 성공 \(result.hash)")
                    guard let resultData = Data.fromHex(result.hash) else{
                        throw TraceUserError.clientError("")
                    }
                    if let receipt = try await getTransactionReceipt(web3: web3!, transactionHash: resultData),
                       let contractAddress = receipt.contractAddress?.address {
                        print("트랜잭션 로그: \(String(describing: receipt.logs))")
                        print("트랜잭션 주소: \(contractAddress)")
                        return (true, contractAddress)
                    } else {
                        print("❌올바른 트랜잭션 영수증 또는 계약 주소를 받지 못했습니다.")
                        throw TraceUserError.clientError("")
                    }
                }else{
                    print("트랜잭션 실행 실패")
                    throw TraceUserError.clientError("")
                }
            }
            else{
                throw TraceUserError.clientError("")
            }
        }catch{
            print("트랜잭션 실패 에러: \(error.localizedDescription)")
            throw TraceUserError.clientError("")
        }
    }

    
    //    트랜젝션 레시피 대기 메서드 200 초 동안 대기
    func getTransactionReceipt(web3: Web3, transactionHash: Data) async throws -> TransactionReceipt? {
        
        // 영수증 조회를 위한 반복 시도
        for _ in 0..<200 {
            if let receipt = try? await web3.eth.transactionReceipt(transactionHash) {
                return receipt
            }
            // 영수증이 아직 준비되지 않았다면 잠시 대기
            try await Task.sleep(nanoseconds: 2_000_000_000) // 예: 2초 대기
        }
        return nil // 영수증을 받지 못한 경우
    }
}
