//
//  ContractNotification.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/24/24.
//

import Foundation
import UIKit
class ContractNotification: KPHWallet{
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "dsf"
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
