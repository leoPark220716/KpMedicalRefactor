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
class KPHWalletContractManager: KPHWalletContract{
    var appManager: NavigationRouter
    init(appManager: NavigationRouter) {
        self.appManager = appManager
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
    func SmartContractConfirm(hospitalId: UInt32, date: BigUInt) {
        var backgroundTask: UIBackgroundTaskIdentifier = .invalid
        backgroundTask = UIApplication.shared.beginBackgroundTask() {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
        DispatchQueue.global(qos: .background).async {
            Task {
                do {
                    print("👀 SmartContractConfirm Start")
                    let password = try self.GetPasswordKeystore(account: self.UserAccount)
                    print("👀 SmartContractConfirm \(password)")
                    let privateKeyData = try self.GetWalletPrivateKey(password: password.password)
                    try await self.getContract()
                    print("👀 SmartContractConfirm \(privateKeyData.base64EncodedString())")
                    print("👀 SmartContractConfirm Start confirm")
                    let confirm = try await self.callConfirmReqeust(privateKey: privateKeyData, hospitalID: hospitalId, date: date, password: password.password)
                    if confirm.success{
                        self.scheduleNotification(key: "contract_request_success")
                    }else{
                        self.scheduleNotification(key: "contract_request_false")
                    }
                    // 추가 작업 수행
                } catch let error as TraceUserError {
                    print("❌SmartContract raceUserError")
                    DispatchQueue.main.async {
                        self.appManager.displayError(ServiceError: error)
                    }
                } catch {
                    print("❌SmartContract error")
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.appManager.displayError(ServiceError: .unowned(error.localizedDescription))
                    }
                }
            }
        }
    }
    
    func tt(){
        var backgroundTask: UIBackgroundTaskIdentifier = .invalid
        backgroundTask = UIApplication.shared.beginBackgroundTask() {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 5) {
            Task{
                self.scheduleNotification(key: "contract_request_success")
            }
        }
        
    }
    
    func scheduleNotification(key: String) {
        let content = UNMutableNotificationContent()
        content.title = "Test"
        content.body = "컨트랙트 요청 처리가 완료되었습니다."
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

}
