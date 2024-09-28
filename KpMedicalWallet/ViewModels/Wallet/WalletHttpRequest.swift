//
//  WalletHttpRequest.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/23/24.
//

import Foundation

class WalletHttpRequest: WalletDataSet{
    
    // 컨트랙트 저장.
    func saveContractAddress(contract: String) async throws{
        do{
            let request = createSaveContractRequest(contract: contract)
            let call = KPWalletAPIManager.init(httpStructs: request, URLLocations: 1)
            let response = try await call.performRequest()
            if response.success{
                if response.data?.status != 201{
                    throw TraceUserError.serverError("")
                }
            }else{
                throw TraceUserError.serverError("")
            }
        }catch{
            throw error
        }
    }
    // 지갑 계정 저장
    func saveWalletAddress(address: String,encrypt_rsa: String) async throws{
        do{
            let request = createSaveWallettRequest(address: address,encrypt_rsa: encrypt_rsa)
            let call = KPWalletAPIManager.init(httpStructs: request, URLLocations: 1)
            let response = try await call.performRequest()
            if response.success{
                if response.data?.status != 201{
                    throw TraceUserError.serverError("")
                }
                await MainActor.run {
                    isLoading = false
                }
            }else{
                throw TraceUserError.serverError("")
            }
        }catch{
            throw error
        }
    }
    
    
    override func setDatas(appManager: NavigationRouter) async {
        do{
            print("Call WalletHttpRequest SetDatas")
            try await super.setDatas(appManager: appManager)
            if walletState{
                try getPubkeyContract()
                try getTransactionList()
            }
        }catch let error as TraceUserError{
            await appManager.displayError(ServiceError: error)
        }catch{
            await appManager.displayError(ServiceError: .unowned(""))
        }
    }
    
    //    퍼블릭키 및 컨트랙트 요청
    func getPubkeyContract() throws {
        Task{
            do{
                let request = createGetContractPubKeyRequest()
                let call = KPWalletAPIManager(httpStructs: request, URLLocations: 1)
                let response = try await call.performRequest()
                if response.success{
                    guard let address = response.data?.data.address else{
                        throw TraceUserError.clientError("")
                        
                    }
                    guard let contract = response.data?.data.contract else{
                        throw TraceUserError.clientError("")
                        
                    }
                    if address != PublicKey{
                        throw TraceUserError.clientError("")
                    }
                    await MainActor.run {
                        PublicKey = address
                        Contract = contract
                    }
                }
            }catch{
                throw error
            }
        }
    }
    
    //    퍼블릭키 및 컨트랙트 요청
    func getContract() async throws -> (String){
        
            do{
                let request = createGetContractPubKeyRequest()
                let call = KPWalletAPIManager(httpStructs: request, URLLocations: 1)
                let response = try await call.performRequest()
                if response.success{
                    guard let contract = response.data?.data.contract else{
                        throw TraceUserError.clientError("getContract")
                    }
                    return contract
                }
                throw TraceUserError.clientError("getContract")
            }catch{
                throw error
            }
    }
    func transactionUpdate(hospitalId: UInt32,msgType: Int,stempUUID: String) async -> (Bool) {
        do{
            let requset =  updateContractStatus(hospitalId: hospitalId,msgType: msgType,stempUUID: stempUUID)
            let call = KPWalletAPIManager(httpStructs: requset, URLLocations: 1)
            let response = try await call.performRequest()
            if let _ = response.data?.data{
                return true
            }else{
                return false
            }
        }catch{
            print("❌transactionUpdate \(error)")
            return false
        }
    }
    // 트랜젝선 리스트 요청
    func getTransactionList() throws {
        Task{
            do{
                let request = createFirstGetTransactionListRequest()
                let call = KPWalletAPIManager(httpStructs: request, URLLocations: 1)
                let response = try await call.performRequest()
                if response.success{
                    guard let datas = response.data?.data else{
                        throw TraceUserError.clientError("")
                        
                    }
                    var tempItems: [WalletModel.AccessItem] = []
                    for item in datas.transactions {
                        tempItems.append(WalletModel.AccessItem(
                            HospitalName: item.hospital_name,
                            Purpose: item.message,
                            State: item.from == UserAccount,
                            Date: datePase(dateString: item.timestamp),
                            blockHash: item.hash,
                            unixTime: item.unixtime,
                            room_key: item.room_key,
                            msg_type: String(item.msg_type),
                            timestamp_uuid: item.timestamp
                        ))
                    }
                    await super .setTrasactionList(list: tempItems)
                }
            }catch{
                throw error
            }
        }
    }
    //    트랜젝션 리스트 페이지네이션
    func pagingGetTransactionList(appManager: NavigationRouter){
        Task{
            do{
                guard let request = createPagesGetTransactionListRequest() else{
                    print("List Item nIl")
                    return
                }
                let call = KPWalletAPIManager(httpStructs: request, URLLocations: 1)
                let response = try await call.performRequest()
                if response.success{
                    guard let datas = response.data?.data else{
                        await appManager.displayError(ServiceError: .clientError(""))
                        return
                    }
                    var tempItems: [WalletModel.AccessItem] = []
                    for item in datas.transactions {
                        tempItems.append(WalletModel.AccessItem(
                            HospitalName: item.hospital_name,
                            Purpose: item.message,
                            State: item.from == UserAccount,
                            Date: datePase(dateString: item.timestamp),
                            blockHash: item.hash,
                            unixTime: item.unixtime,
                            room_key: item.room_key,
                            msg_type: String(item.msg_type),
                            timestamp_uuid: item.timestamp
                        ))
                    }
                    await super .setTrasactionList(list: tempItems)
                }
            }catch let error as TraceUserError{
                await appManager.displayError(ServiceError: error)
            }catch{
                await appManager.displayError(ServiceError: .unowned(error.localizedDescription))
            }
        }
    }
    
    func getRSAencryptKey(address: String) async throws -> String{
        do{
            let request = getSecKeyInServerRequest(address: address)
            let call = KPWalletAPIManager(httpStructs: request, URLLocations: 1)
            let response = try await call.performRequest()
            guard let encryptRsa = response.data?.data.encrypt_rsa else{
                throw TraceUserError.serverError("")
            }
            return encryptRsa
        }catch{
            throw error
        }
    }
    private func datePase(dateString: String) -> String{
        
        // DateFormatter 인스턴스 생성 및 설정
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "M.dd"
        
        // 문자열을 Date 객체로 변환
        if let date = inputFormatter.date(from: dateString) {
            // Date 객체를 원하는 형식의 문자열로 변환
            let formattedDateString = outputFormatter.string(from: date)
            print(formattedDateString) // "5.25"
            return formattedDateString
        } else {
            return "1"
        }
    }
    private func createFirstGetTransactionListRequest()-> http<Empty?,KPApiStructFrom<WalletModel.getListData>>{
        return http(
            method: "GET",
            urlParse: "v2/chat/transactions?limit=\(10)",
            token: token,
            UUID: UserVariable.GET_UUID()
        )
    }
    
    
    private func createPagesGetTransactionListRequest() -> http<Empty?, KPApiStructFrom<WalletModel.getListData>>? {
        guard let lastTransaction = TrasactionList.last else {
            // 로그를 남기거나, 기본값을 반환하거나, nil을 반환합니다.
            print("TransactionList is empty.")
            return nil
        }
        return http(
            method: "GET",
            urlParse: "v2/chat/transactions?room_key=\(lastTransaction.room_key)&msg_type=\(lastTransaction.msg_type)&timestamp_uuid=\(lastTransaction.timestamp_uuid)&limit=10",
            token: token,
            UUID: UserVariable.GET_UUID()
        )
    }

    
    private func createSaveContractRequest(contract: String)-> http<WalletModel.SaveContract?,KPApiStructFrom<WalletModel.SaveContractResponseData>>{
        let body = WalletModel.SaveContract(access_token: token, uid: UserVariable.GET_UUID(), contract: contract)
        return http(
            method: "POST",
            urlParse: "users/contract",
            token: token,
            UUID: UserVariable.GET_UUID(),
            requestVal: body
        )
        
    }
    private func createSaveWallettRequest(address: String,encrypt_rsa: String)-> http<WalletModel.SaveWalletData?,KPApiStructFrom<WalletModel.WalletInfomationResponse>>{
        let body = WalletModel.SaveWalletData(access_token: token, uid: UserVariable.GET_UUID(), address: address, encrypt_rsa: encrypt_rsa, type: 0)
        return http(
            method: "POST",
            urlParse: "users/wallet",
            token: token,
            UUID: UserVariable.GET_UUID(),
            requestVal: body
        )
    }
    private func createGetContractPubKeyRequest() -> http<Empty?, KPApiStructFrom<WalletModel.WalletInfomationResponse>>{
        return http(
            method: "GET",
            urlParse: "v2/users/cryptos",
            token: token,
            UUID: UserVariable.GET_UUID())
    }
    private func getSecKeyInServerRequest(address: String) -> http<WalletModel.SaveWalletData?,KPApiStructFrom<WalletModel.WalletInfomationResponse>>{
        let body = WalletModel.SaveWalletData(access_token: token, uid: UserVariable.GET_UUID(), address: address, encrypt_rsa: "", type: 1)
        return http(
            method: "POST",
            urlParse: "users/wallet",
            token: token,
            UUID: body.uid,
            requestVal: body)
    }
    
    private func updateContractStatus(hospitalId: UInt32,msgType: Int,stempUUID: String)-> http<WalletModel.updateContractBody?,WalletModel.updateContractResponse>{
        let body = WalletModel.updateContractBody(room_key: "\(hospitalId):\(UserAccount)", msg_type: msgType, timestamp_uuid: stempUUID)
        return http(
            method: "PATCH",
            urlParse: "v2/chat/transactions",
            token: token,
            UUID: UserVariable.GET_UUID(),
            requestVal: body
        )
    }
}
