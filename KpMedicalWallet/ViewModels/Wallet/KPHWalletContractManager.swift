//
//  KPHWalletContractManafger.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/24/24.
//

import Foundation
import Web3Core
import BigInt
import UIKit
class KPHWalletContractManager: WalletContractCrypto{
    var appManager: NavigationRouter
    var socket: ChatHandler
    var contract: String = ""
    init(appManager: NavigationRouter,socket: ChatHandler) {
        self.appManager = appManager
        self.socket = socket
        super.init()
        Task{
            do{
                try SetTokenAndAccount(appManager: appManager)
                try await setUpWeb3Datas()
            }catch let error as TraceUserError{
                await appManager.displayError(ServiceError: error)
            }catch{
                await appManager.displayError(ServiceError: .unowned(error.localizedDescription))
            }
        }
    }
    // 저장 요청 수락
    func SmartContractConfirm(hospitalId: UInt32, date: BigUInt,stempUUID: String) {
        var backgroundTask: UIBackgroundTaskIdentifier = .invalid
        backgroundTask = UIApplication.shared.beginBackgroundTask() {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
        DispatchQueue.global(qos: .background).async {
            Task {
                do {
                    print("👀 SmartContractConfirm Start")
                    self.contract =  try await self.getContract()
                    print("👀 SmartContractConfirm \(self.contract)")
                    let password = try self.GetPasswordKeystore(account: self.UserAccount)
                    print("👀 SmartContractConfirm \(password)")
                    let privateKeyData = try self.GetWalletPrivateKey(password: password.password)
                    print("👀 SmartContractConfirm \(privateKeyData.base64EncodedString())")
                    print("👀 SmartContractConfirm Start confirm")
                    let confirm = try await self.callConfirmReqeust(privateKey: privateKeyData, hospitalID: hospitalId, date: date, password: password.password,contractAddress: self.contract)
                    if confirm.success{
                        self.scheduleNotification(key: "contract_request_success")
                        _ = await self.transactionUpdate(hospitalId: hospitalId, msgType: 6, stempUUID: self.socket.stempUUID)
                        if self.CheckSocketConnect(){
                            _ = await self.socket.sendTransactionConfirm(message: "저장요청을 수락 하셨습니다.", blockHash: confirm.txHash)
                        }else{
                            await self.socket.Connect()
                            _ = await self.socket.sendTransactionConfirm(message: "저장요청을 수락 하셨습니다.", blockHash: confirm.txHash)
                            self.socket.disconnect()
                        }
                    }else{
                        self.scheduleNotification(key: "contract_request_false")
                    }
                    // 추가 작업 수행
                } catch let error as TraceUserError {
                    print("❌SmartContract raceUserError \(error)")
                    self.scheduleNotification(key: "contract_request_false")
                } catch {
                    print("❌SmartContract error")
                    print(error.localizedDescription)
                    self.scheduleNotification(key: "contract_request_false")
                }
            }
        }
    }
    // 수정 요청 수락
    func SmartContractEdit(hospitalId: UInt32, date: BigUInt,index: BigUInt,stempUUID: String){
        var backgroundTask: UIBackgroundTaskIdentifier = .invalid
        backgroundTask = UIApplication.shared.beginBackgroundTask() {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
        DispatchQueue.global(qos: .background).async {
            Task{
                do{
                    print("👀 SmartContractConfirm Start")
                    self.contract =  try await self.getContract()
                    print("👀 SmartContractConfirm \(self.contract)")
                    let password = try self.GetPasswordKeystore(account: self.UserAccount)
                    print("👀 SmartContractConfirm \(password)")
                    let privateKeyData = try self.GetWalletPrivateKey(password: password.password)
                    print("👀 SmartContractConfirm \(privateKeyData.base64EncodedString())")
                    print("👀 SmartContractConfirm Start confirm")
                    let confirm = await self.callEditSmartContract(privateKey: privateKeyData, hospitalID: hospitalId, date: date, index: index, password: password.password, contractAddress: self.contract)
                    if confirm.success{
                        self.scheduleNotification(key: "contract_request_success")
                        _ = await self.transactionUpdate(hospitalId: hospitalId, msgType: 7, stempUUID: self.socket.stempUUID)
                        if self.CheckSocketConnect(){
                            _ = await self.socket.sendTransactionConfirm(message: "수정요청을 수락 하셨습니다.", blockHash: confirm.txHash)
                        }else{
                            await self.socket.Connect()
                            _ = await self.socket.sendTransactionConfirm(message: "수정요청을 수락 하셨습니다.", blockHash: confirm.txHash)
                            self.socket.disconnect()
                        }
                    }else{
                        self.scheduleNotification(key: "contract_request_false")
                    }
                }catch let error as TraceUserError {
                    print("❌SmartContract raceUserError \(error)")
                    self.scheduleNotification(key: "contract_request_false")
                } catch {
                    print("❌SmartContract error")
                    print(error.localizedDescription)
                    self.scheduleNotification(key: "contract_request_false")
                }
            }
        }
    }
    // 공유요청 수락
    func SmartContractSharer(){
        var backgroundTask: UIBackgroundTaskIdentifier = .invalid
        backgroundTask = UIApplication.shared.beginBackgroundTask() {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
        DispatchQueue.global(qos: .background).async {
            Task{
                do{
                    print("👀 SmartContractConfirm Start")
                    self.contract =  try await self.getContract()
                    print("👀 SmartContractConfirm \(self.contract)")
                    let password = try self.GetPasswordKeystore(account: self.UserAccount)
                    print("👀 SmartContractConfirm \(password)")
                    let privateKeyData = try self.GetWalletPrivateKey(password: password.password)
                    print("👀 SmartContractConfirm \(privateKeyData.base64EncodedString())")
                    print("👀 SmartContractConfirm Start callConfirmReadRecode")
                    let confirm = try await self.callConfirmReadRecode(privateKey: privateKeyData, param1: self.socket.paramDepartCode, param2: BigUInt(self.socket.hospitalId), methodName: "getRecordToShare", password: password.password, contractAddress: self.contract)
                    if !confirm.success{
                        self.scheduleNotification(key: "contract_request_false")
                        return
                    }
                    let parshContract = self.ReturningUnDecodArray(dic: confirm.result)
                    if !parshContract.success{
                        print("❌parshContract")
                        self.scheduleNotification(key: "contract_request_false")
                        return
                    }
                    guard let contractResult = parshContract.contractResult else{
                        self.scheduleNotification(key: "contract_request_false")
                        print("❌contractResult")
                        return
                    }
                    let setSymetricKey = self.getSymetricKeys(array: contractResult)
                    if !setSymetricKey.success{
                        self.scheduleNotification(key: "contract_request_false")
                        print("❌setSymetricKey")
                        return
                    }
                    guard let symetricContractResult = setSymetricKey.contractResult else{
                        self.scheduleNotification(key: "contract_request_false")
                        print("❌symetricContractResult")
                        return
                    }
                    var paramArray: [SharedData] = []
                    for indexItem in symetricContractResult{
                        paramArray.append(SharedData(index: indexItem.index, hospital_id: BigUInt(self.socket.hospitalId), hospital_key: self.CryptoSecKey(pubkey: self.socket.cryptPubkey, decodeString: indexItem.patient_key)))
                    }
                    let shareConfirm = await self.callShaerReqeust(key: privateKeyData, contractAddress: self.contract,param: paramArray, password: password.password)
                    if shareConfirm.success{
                        self.scheduleNotification(key: "contract_request_success")
                        _ = await self.transactionUpdate(hospitalId: UInt32(self.socket.hospitalId), msgType: 8, stempUUID: self.socket.stempUUID)
                        if self.CheckSocketConnect(){
                            _ = await self.socket.sendTransactionConfirm(message: "공유요청을 수락 하셨습니다.", blockHash: shareConfirm.txHash)
                        }else{
                            await self.socket.Connect()
                            _ = await self.socket.sendTransactionConfirm(message: "공유요청을 수락 하셨습니다.", blockHash: shareConfirm.txHash)
                            self.socket.disconnect()
                        }
                    }else{
                        print("❌shareConfirm.success")
                        self.scheduleNotification(key: "contract_request_false")
                    }
                }catch let error as TraceUserError {
                    print("❌SmartContract raceUserError \(error)")
                    self.scheduleNotification(key: "contract_request_false")
                } catch {
                    print("❌SmartContract error")
                    print(error.localizedDescription)
                    self.scheduleNotification(key: "contract_request_false")
                }
            }
        }
    }
    func scheduleNotification(key: String) {
        let content = UNMutableNotificationContent()
        content.title = "Test"
        content.body = PlistManager.shared.string(forKey: key)
        content.sound = .default
        content.userInfo = returnUserInfo(title: content.title, body: content.body)
        
        // 10초 뒤에 알림을 발송합니다.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "MyNotification", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print("Notification scheduling error: \(error.localizedDescription)")
            }
        }
    }
    private func returnUserInfo(title: String, body: String) -> [AnyHashable: Any] {
        let userInfo =  [
            "aps": [
                "alert":[
                    "title": "\(title)",
                    "body":"\(body)"
                ],
                "sound":"default"
            ],
            "chat" : [
                "from" : "12",
                "name" : "hs"
            ]
        ]
        return userInfo
    }
    private func CheckSocketConnect() -> Bool{
        return socket.webSocketTask?.state == .running
    }
    
}
