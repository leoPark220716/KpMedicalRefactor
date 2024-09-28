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
    // 지갑 복구
    func recoverWallet(password: String) throws -> String{
        do {
            guard let keystore = try BIP32Keystore(mnemonics: Mnemonicse, password: password) else {
                print("❌ keystore ")
                throw TraceUserError.clientError("recoverWallet keystore")
            }
            //            keystore 직렬화
            guard let keystoreData = try keystore.serialize()else{
                print("❌ keystoreData")
                throw TraceUserError.clientError("recoverWallet keystoreData")
            }
            //            직렬화 keystore keychain 에 저장
            let saveStatus = saveToKeyChain(keystoreData: keystoreData, account: UserAccount)
            if saveStatus != errSecSuccess {
                print("❌ saveToKeyChain \(saveStatus)")
                throw TraceUserError.clientError("recoverWallet saveStatus")
            }
            // 복구된 계정의 첫 번째 주소를 가져옵니다.
            guard let address = keystore.addresses?.first else {
                throw TraceUserError.clientError("recoverWallet address")
            }
            return address.address
        } catch {
            throw error
        }
    }
    
    // 지갑 생성
    func generateWallet() throws -> (success: Bool,privateKey: String, WalletPublicKey: String) {
        guard !Mnemonicse.isEmpty else {
            print("니모닉 빈배열")
            throw TraceUserError.clientError("generateWallet Mnemonicse")
        }
        do {
            //            keystore 생성.
            guard let keystore = try BIP32Keystore(mnemonics: Mnemonicse, password: password) else {
                print("keystore 생성 실패")
                throw TraceUserError.clientError("generateWallet keystore")
            }
            // 새로운 계정을 생성합니다.
            try keystore.createNewChildAccount(password: password)
            //            keystore 직렬화
            guard let keystoreData = try keystore.serialize()else{
                print("직렬화 실패")
                throw TraceUserError.clientError("generateWallet keysotredata")
            }
            //            직렬화 keystore keychain 에 저장
            let saveStatus = saveToKeyChain(keystoreData: keystoreData, account: UserAccount)
            if saveStatus != errSecSuccess {
                print("직렬화??? \(saveStatus)")
                throw TraceUserError.clientError("generateWallet saveStatus")
            }
            // 첫 번째 주소를 가져옵니다.
            if let address = keystore.addresses?.first {
                let privateKeyData = try keystore.UNSAFE_getPrivateKeyData(password: password, account: address)
                let privateKeyHexString = privateKeyData.toHexString()
                self.keystore = keystore
                self.keystoreData = keystoreData
                if self.keystore == nil || self.keystoreData == nil{
                    print("❌ 지갑 생성 과정 데이터 객체 할당 실패")
                    throw TraceUserError.clientError("generateWallet keystoreaddress")
                }
                
                return (true,privateKeyHexString,address.address)
            } else {
                print("지갑 주소 가져오기 실패")
                throw TraceUserError.clientError("generateWallet else")
            }
        } catch {
            print("지갑생성 에러 \(error)")
            throw TraceUserError.clientError(error.localizedDescription)
        }
    }
    // 스마트컨트랙트 배포
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
                        throw TraceUserError.clientError("SmartContractDeploy reusltData")
                    }
                    print("✅ Tx Hash \(result.hash)")
                    if let receipt = try await getTransactionReceipt( transactionHash: resultData),
                       let contractAddress = receipt.contractAddress?.address {
                        print("트랜잭션 로그: \(String(describing: receipt.logs))")
                        print("트랜잭션 주소: \(contractAddress)")
                        return (true, contractAddress)
                    } else {
                        print("❌올바른 트랜잭션 영수증 또는 계약 주소를 받지 못했습니다.")
                        throw TraceUserError.clientError("SmartContractDeploy resultData else")
                    }
                }else{
                    print("트랜잭션 실행 실패")
                    throw TraceUserError.clientError("SmartContractDeploy else")
                }
            }
            else{
                throw TraceUserError.clientError("SmartContractDeploy else")
            }
        }catch{
            print("트랜잭션 실패 에러: \(error.localizedDescription)")
            throw TraceUserError.clientError("")
        }
    }
    private func reciptCheck(result: TransactionSendingResult) async throws ->(success:Bool,txHash: String){
        guard let resultData = Data.fromHex(result.hash) else{
            print("✅\(result.hash)")
            return (success: false, txHash: result.hash)
        }
        guard let receipt = try await getTransactionReceipt(transactionHash: resultData) else{
            print("✅\(result.hash)")
            return (success: false, txHash: result.hash)
        }
        if let firstLog = receipt.logs.first{
            let hexString = firstLog.data.toHexString()
            if let hexValue = BigUInt(hexString, radix: 16) {
                print("✅ Tx receipt Log : \(firstLog)")
                let decimalValue = String(hexValue)
                if decimalValue == "1"{
                    return (success: true, txHash: result.hash)
                }else{
                    return (success: false, txHash: result.hash)
                }
            }
        }
        return (success: false, txHash: result.hash)
    }
    
    // 스마트컨트랙트 작성 (저장 수락)
    func callConfirmSaveRecode(privateKey: Data,hospitalID: UInt32,date: BigUInt,password: String,contractAddress: String)  async throws -> (success:Bool,txHash: String) {
        do{
            print("Start callConfirmSaveRecode")
            guard let web3 = web3 else {
                print("❌callConfirmSaveRecode web3")
                throw TraceUserError.clientError("")
            }
            guard let abi = abi else {
                print("❌callConfirmSaveRecode abi")
                throw TraceUserError.clientError("")
            }
            guard let accountAddress = accountAddress else{
                print("❌callConfirmSaveRecode accountAddress")
                throw TraceUserError.clientError("")
            }
            let contract = Web3.Contract(web3: web3, abiString: abi, at: EthereumAddress(contractAddress), abiVersion: 2)
            guard let trasaction = contract?.createWriteOperation(
                "confirmSaveRecord",
                parameters: [hospitalID,date] as [AnyObject],
                extraData: Data()
            )else{
                print("❌callConfirmSaveRecode contract?.createWriteOperation")
                throw TraceUserError.clientError("")
            }
            let gasNonce = try await returnGasNonce()
            print("👀 gas : \(gasNonce.gas)")
            print("👀 nonce : \(gasNonce.nonce)")
            trasaction.transaction.nonce = gasNonce.nonce
            trasaction.transaction.from = accountAddress
            trasaction.transaction.chainID = ChainID
            trasaction.transaction.gasPrice = gasNonce.gas
            let estimatedGasLimit = try await web3.eth.estimateGas(for: trasaction.transaction, onBlock: .pending)
            trasaction.transaction.gasLimit = estimatedGasLimit
            try trasaction.transaction.sign(privateKey: privateKey)
            let result = try await trasaction.writeToChain(password: password,sendRaw: true)
            let returnVal = try await reciptCheck(result: result)
            return returnVal
        }catch let error as TraceUserError{
            throw error
        }catch let error as Web3Error{
            print("❌Web3Error")
            print(error.errorDescription as Any)
            return (success: false, txHash: "result.hash")
        }catch{
            print("❌ error")
            return (success: false, txHash: "result.hash")
        }
    }
    
    //    트랜젝션 레시피 대기 메서드 200 초 동안 대기
    private func getTransactionReceipt(transactionHash: Data) async throws -> TransactionReceipt? {
        // 영수증 조회를 위한 반복 시도
        for _ in 0..<10 {
            if let receipt = try? await web3?.eth.transactionReceipt(transactionHash) {
                return receipt
            }
            // 영수증이 아직 준비되지 않았다면 잠시 대기
            try await Task.sleep(nanoseconds: 2_000_000_000) // 예: 2초 대기
        }
        return nil // 영수증을 받지 못한 경우
    }
    private func getTransactionReceipt(web3: Web3,transactionHash: Data) async throws -> TransactionReceipt? {
        // 영수증 조회를 위한 반복 시도
        for _ in 0..<10 {
            if let receipt = try? await web3.eth.transactionReceipt(transactionHash) {
                return receipt
            }
            // 영수증이 아직 준비되지 않았다면 잠시 대기
            try await Task.sleep(nanoseconds: 2_000_000_000) // 예: 2초 대기
        }
        return nil // 영수증을 받지 못한 경우
    }
    // 공개키 추출
    func GetWalletPublicKey(account: String) throws -> ( isNil: Bool,PublicKey:String) {
        guard let keystoreData = loadFromKeychain(account: account) else {
            print("Failed to load keystore")
            return (true, "")
        }
        guard let keystore = BIP32Keystore(keystoreData)else{
            throw TraceUserError.clientError("")
        }
        guard let accountAddress = keystore.addresses?.first else {
            throw TraceUserError.clientError("")
        }
        print("사용될 공개키 \(accountAddress.address)")
        return (false, accountAddress.address)
    }
    
    func GetWalletPrivateKey(password: String) throws -> Data {
        guard let accountAddress = keystore?.addresses?.first else{
            throw TraceUserError.clientError("")
        }
        do{
            let privateKeyData = try keystore?.UNSAFE_getPrivateKeyData(password: password, account: accountAddress)
            guard let key = privateKeyData else{
                throw TraceUserError.clientError("")
            }
            return key
        }catch{
            throw error
        }
    }
    
    //    저장요청 컨트랙트 작성
    func callConfirmReqeust(privateKey: Data, hospitalID: UInt32, date: BigUInt, password: String, contractAddress: String) async throws -> (success:Bool,txHash:String) {
        do{
            _ = await sendTxForConfirm(account: UserAccount, key: privateKey)
            let result = try await  callConfirmSaveRecode(privateKey: privateKey, hospitalID: hospitalID, date: date, password: password,contractAddress: contractAddress)
//            let result = await callConfirmSaveRecord(key: privateKey, hospitalID: hospitalID, date: date, password: password)
            print("👀 callConfirmSaveRecode 1\(result)")
            if result.success{
                return result
            }
            let tx2 = await sendTxForConfirm(account: UserAccount, key: privateKey)
            if tx2{
                let Second_result = try await callConfirmSaveRecode(privateKey: privateKey, hospitalID: hospitalID, date: date, password: password,contractAddress: contractAddress)
                return Second_result
            }
            return (false,"false")
        }catch{
            throw error
        }
    }
    func sendTxForConfirm(account: String, key: Data) async -> Bool {
        do {
            // keystore 에 있는 계정 주소 뽑아옴
            guard let accountAddress = keystore!.addresses?.first else {
                print("계정 주소를 찾을 수 없습니다.")
                return false
            }
            print("Create Nonce")
            // 트랜잭션 설정
            let gasNonce = try await returnGasNonce()
            print(gasNonce)
            let tos = "0x1099530d4F290CcAb9bcdfb059CFF84922827526"
            var tx: CodableTransaction = .emptyTransaction
            tx.from = accountAddress
            tx.value = 0
            tx.nonce = gasNonce.nonce
            guard let toAddress = EthereumAddress(tos) else {
                print("Invalid 'to' address")
                return false
            }
            tx.to = toAddress
            tx.gasPrice = gasNonce.gas
            tx.chainID = ChainID
            let estimatedGasLimit = try await web3!.eth.estimateGas(for: tx, onBlock: .latest)
            tx.gasLimit = estimatedGasLimit
            
            try tx.sign(privateKey: key)
            print("개인키 데이터 길이: \(key.count) 바이트")
            guard let transactionEncode = tx.encode() else{
                print("트렌젝션 인코딩 실패")
                return false
            }
            
            let result = try await web3!.eth.send(raw: transactionEncode)
            guard let resultData = Data.fromHex(result.hash) else{
                return false
            }
            do{
                print("Transaction Hash")
                print(result.hash)
                if let receipt = try await getTransactionReceipt(transactionHash: resultData){
                    print("트랜잭션 로그: \(String(describing: receipt.logs))")
                    return true
                }else{
                    print("레시피를 받지 못함")
                    return false
                }
            }
            catch{
                print("receipt \(error.localizedDescription)")
                return false
            }
        } catch {
            print("트랜잭션 실패 에러: \(error.localizedDescription)")
            return false
        }
    }
    // 스컨 작성시 Nonce 이상 문제 해결을위한 빈 거래 생성
    func sendTransactionEmpty(privateKey: Data) async -> Bool {
        do{
            guard let web3 = web3 else {
                print("❌sendTransactionEmpty web3")
                throw TraceUserError.clientError("")
            }
            guard let accountAddress = accountAddress else{
                print("❌sendTransactionEmpty accountAddress")
                throw TraceUserError.clientError("")
            }
            guard let toAddress = EthereumAddress(try UserVariable.MANAGER_ACCOUNT()) else{
                print("❌sendTransactionEmpty toAddress")
                throw TraceUserError.clientError("")
            }
            let gasNonce = try await returnGasNonce()
            var tx: CodableTransaction = .emptyTransaction
            tx.from = accountAddress
            tx.value = 0
            tx.nonce = gasNonce.nonce
            tx.chainID = ChainID
            tx.to = toAddress
            let estimatedGasLimit = try await web3.eth.estimateGas(for: tx, onBlock: .latest)
            tx.gasLimit = estimatedGasLimit
            try tx.sign(privateKey: privateKey)
            guard let txEncode = tx.encode() else{
                print("❌sendTransactionEmpty txEncode")
                throw TraceUserError.clientError("")
            }
            let result = try await web3.eth.send(raw: txEncode)
            guard let resultData = Data.fromHex(result.hash) else{
                print("❌sendTransactionEmpty resultData \(result)")
                throw TraceUserError.clientError("")
            }
            guard let receipt = try await getTransactionReceipt(transactionHash: resultData) else{
                print("❌sendTransactionEmpty receipt \(result.hash)")
                throw TraceUserError.clientError("")
            }
            print("✅ sendTransactionEmpty \(receipt.logs)")
            return true
        }catch{
            return false
        }
    }
    func callConfirmSaveRecord(key: Data, hospitalID: UInt32, date: BigUInt,password: String) async -> (success:Bool,txHash: String) {
        let maskedValue = hospitalID & 0xFFFFFF
        print( "💶 HospitalID \(hospitalID)")
        print( "💶 unixTime \(date)")
        guard let keystoreData = loadFromKeychain(account: UserAccount) else {
            print("Failed to load keystore")
            return (false,"")
        }

        guard let keystore = BIP32Keystore(keystoreData) else {
            print("keystore 생성 실패")
            return (false,"")
        }
        let keystoreManager = KeystoreManager([keystore])
        if providerURL == nil{
            return (false, "")
        }
        do {
            let provider = try await Web3HttpProvider(url: providerURL!, network: .Custom(networkID: BigUInt(142537)), keystoreManager: keystoreManager)
            let web3 = Web3(provider: provider)
            
            // keystore 에 있는 계정 주소 뽑아옴
            guard let accountAddress = keystore.addresses?.first else {
                print("계정 주소를 찾을 수 없습니다.")
                return (false,"")
            }
            print("👀 account : \(accountAddress.address)")
            print("👀 Contract : \("0xb397d0C94D920680D73b31c3e0eCb103d909B69a")")
            // abi 값 추출
            guard let abiUrl = Bundle.main.url(forResource: "PersonalRecords_sol_PersonalRecords", withExtension: "json"),
                  let abiString = try? String(contentsOf: abiUrl) else {
                print("ABI 파일 실패")
                return (false,"")
            }
            let contract = Web3.Contract(web3: web3, abiString: abiString, at: EthereumAddress("0xb397d0C94D920680D73b31c3e0eCb103d909B69a"), abiVersion: 2)
            print("Create Contract")
            // 함수 호출 트랜잭션 생성
            guard let transaction = contract?.createWriteOperation(
                "confirmSaveRecord",
                parameters: [maskedValue,date] as [AnyObject],
                extraData: Data()
            ) else {
                print("트랜잭션 생성 실패")
                return (false,"")
            }
            print("Create Transaction")
            let maxGasPrice = BigUInt(50) * BigUInt(10).power(9) // 예: 50 Gwei
            let gasPrice = try await web3.eth.gasPrice()
            print("Current gas price (\(gasPrice)) exceeds the configured max gas price (\(maxGasPrice))")
            
            guard gasPrice <= maxGasPrice else {
                print("Current gas price (\(gasPrice)) exceeds the configured max gas price (\(maxGasPrice))")
                return (false,"")
            }
            print("Create Nonce")
            // 트랜잭션 설정
            let currentNonce = try await web3.eth.getTransactionCount(for: accountAddress, onBlock: .latest)
            let increasedGasPrice = gasPrice * 120 / 100

            print("Current nonce: \(currentNonce)")
            transaction.transaction.nonce = currentNonce
            transaction.transaction.from = accountAddress
            transaction.transaction.chainID = ChainID
            transaction.transaction.gasPrice = increasedGasPrice
            print("Current gas price (\(gasPrice)) exceeds the configured max gas price (\(maxGasPrice))")
            let estimatedGasLimit = try await web3.eth.estimateGas(for: transaction.transaction, onBlock: .latest)
            transaction.transaction.gasLimit = estimatedGasLimit
            try! transaction.transaction.sign(privateKey: key)
            let result = try await transaction.writeToChain(password: password, sendRaw: true)
            guard let resultData = Data.fromHex(result.hash) else {
                return (false,"")
            }
            print("Current gas price (\(gasPrice)) exceeds the configured max gas price (\(estimatedGasLimit))")
            do{
                print("Transaction Hash")
                print(result.hash)
                if let receipt = try await getTransactionReceipt(web3: web3, transactionHash: resultData){
                    if let firstLog = receipt.logs.first {
                        print("Address: \(firstLog.address.address)")
                        print("Block Hash: \(firstLog.blockHash.toHexString())")
                        print("Block Number: \(firstLog.blockNumber)")
                        print("Data: \(firstLog.data.toHexString())")
                        let hexString = firstLog.data.toHexString()
                        if let hexValue = BigUInt(hexString, radix: 16) {
                            let decimalValue = String(hexValue)
                            print("16진수 값: \(hexString)")
                            print("10진수 값: \(decimalValue)")
                        } else {
                            print("잘못된 16진수 값")
                        }
                        print("Log Index: \(firstLog.logIndex)")
                        print("Removed: \(firstLog.removed)")
                        print("Topics: \(firstLog.topics.map { $0.toHexString()})")
                        print("Transaction Hash: \(firstLog.transactionHash.toHexString())")
                        print("Transaction Index: \(firstLog.transactionIndex)")
                    }
                    return (true,result.hash)
                }else{
                    print("레시피를 받지 못함")
                    return (false,"")
                }
            }
            catch{
                print("receipt \(error.localizedDescription)")
                return (false,"")
            }
        } catch {
            print("트랜잭션 실패 에러: \(error.localizedDescription)")
            return (false,"")
        }
    }
}
