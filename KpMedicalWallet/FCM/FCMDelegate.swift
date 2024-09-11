//
//  FCMDelegate.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/11/24.
//

import Foundation
import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications


class FCMDelegate: UIResponder, UIApplicationDelegate,ObservableObject{
    var app: KpMedicalWalletApp?
    
    
    // 앱이 켜졌을 때
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // 파이어베이스 설정
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        
        
        // Setting Up Notifications...
        // 원격 알림 등록
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOption,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,Error in
                if didAllow {
                    print("Push: 권한 허용")
                } else {
                    print("Push: 권한 거부")
                }
            })
        }
        
        
        
        // Setting Up Cloud Messaging...
        // 메세징 델리겟f
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        return true
    }
        
}
extension FCMDelegate: UNUserNotificationCenterDelegate{
    
    private func extractName(from userInfo: [AnyHashable: Any]) -> String {
        if let aps = userInfo["aps"] as? [String: Any],
           let alert = aps["alert"] as? [String: Any],
           let title = alert["title"] as? String {
            return title
        } else {
            return "False"
        }
    }
    private func extractMessage(from userInfo: [AnyHashable: Any]) -> String {
        if let aps = userInfo["aps"] as? [String: Any],
           let alert = aps["alert"] as? [String: Any],
           let body = alert["body"] as? String {
            return body
        } else {
            return "False"
        }
    }
    private func extractId(from userInfo: [AnyHashable: Any]) -> String {
        if let chat = userInfo["chat"] as? [String: Any] {
            return extractFromField(from: chat)
        } else if let chatString = userInfo["chat"] as? String,
                  let chatData = chatString.data(using: .utf8) {
            return decodeChatData(chatData)
        } else {
            print("Chat data is not in the expected format or missing.")
            return ""
        }
    }
    private func extractFromField(from chat: [String: Any]) -> String {
        if let from = chat["from"] as? String {
            return from
        } else {
            return ""
        }
    }
    
    private func decodeChatData(_ data: Data) -> String {
        do {
            if let chatDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                return extractFromField(from: chatDict)
            } else {
                print("Failed to decode chat JSON.")
                return ""
            }
        } catch {
            print("Error decoding chat JSON: \(error)")
            return ""
        }
    }
    private func extractTimestamp(from userInfo: [AnyHashable: Any]) -> String {
        if let chat = userInfo["chat"] as? [String: Any],
           let timestamp = chat["timestamp"] as? String {
            return timestamp
        } else if let chatString = userInfo["chat"] as? String,
                  let chatData = chatString.data(using: .utf8) {
            return decodeTimestamp(chatData)
        } else {
            return "Timestamp not available."
        }
    }

    private func decodeTimestamp(_ data: Data) -> String {
        do {
            if let chatDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let timestamp = chatDict["timestamp"] as? String {
                return timestamp
            } else {
                return "Failed to decode timestamp."
            }
        } catch {
            return "Error decoding chat JSON for timestamp: \(error)"
        }
    }


    private func extractMsgTypeField(from chat: [String: Any]) -> String {
        if let msg_type = chat["msg_type"] as? Int {
            return String(msg_type)
        } else {
            return ""
        }
    }
    // 새로운 함수 추가
    private func extractMsgType(from userInfo: [AnyHashable: Any]) -> String {
        if let chat = userInfo["chat"] as? [String: Any] {
            return extractMsgTypeField(from: chat)
        } else if let chatString = userInfo["chat"] as? String,
                  let chatData = chatString.data(using: .utf8) {
            return decodeMsgType(chatData)
        } else {
            print("Chat data is not in the expected format or missing.")
            return ""
        }
    }

    private func decodeMsgType(_ data: Data) -> String {
        do {
            if let chatDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let msg_type = chatDict["msg_type"] as? Int {
                return String(msg_type)
            } else {
                return "Failed to decode msg_type."
            }
        } catch {
            return "Error decoding chat JSON for msg_type: \(error)"
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        //        노티피케이션이 탭됐을 때 오는 댈리게이트
        let userInfo = response.notification.request.content.userInfo
        let name = extractName(from: userInfo)
        let id = extractId(from: userInfo)
        // Handle or display the results as needed
        print("👀 \(name)")
        print("👀 \(id)")
        let stringURL = "KpMedicalApp://chat?id=0&name=\(name)&hos_id=\(id)"
        let url = URL(string: stringURL)
        if name != "False"{
//            app?.handleDeeplink(from: url!)
        }
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        
        let userInfo = notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        print("call in UNUserNotificationCenter : \(userInfo)")
        let id = extractId(from: userInfo)
        let msg = extractMessage(from: userInfo)
        let timeStemp = extractTimestamp(from: userInfo)
        print("👀 TimeStemp \(timeStemp)")
//        app?.authViewModel.UpdateChatItem(hospitalId: id, msg: msg,timestemp: timeStemp)
        print("👀👀👀👀👀👀👀👀👀👀👀👀")
//        let msgType = extractMsgType(from: userInfo) // msg_type 값을 추출
//        printContent(msgType)
//        let isCounselingNotificationEnabled = UserDefaults.standard.bool(forKey: "counselingNotification")
//        if isCounselingNotificationEnabled{
            return [.sound, .badge, .banner, .list]
//        }else{
//            return []
//        }
        
    }
}
extension FCMDelegate: MessagingDelegate{
    
    func application(_ application: UIApplication,
                         didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            Messaging.messaging().apnsToken = deviceToken
    }
    // fcm 등록 토큰을 받았을 때
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let app = app else{
            return
        }
//        로그인 유효성 검사.
        if app.router.token != "" {
            // Store this token to firebase and retrieve when to send message to someone...
            let dataDict: [String: String] = ["token": fcmToken ?? ""]
            if fcmToken != ""{
                let token = fcmToken
                if let token = token {
                    app.router.fcmToken = token
                }
                NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
            }
            // Store token in Firestore For Sending Notifications From Server in Future...
            print(dataDict)
        }
    }
}
