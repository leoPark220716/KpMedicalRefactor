//
//  Socket.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/26/24.
//

import Foundation

class Socket: ObservableObject{
    var webSocketTask: URLSessionWebSocketTask?
    var hospitalId: Int
    var account: String
    var token: String
    var fcmToken: String
    var appManager: NavigationRouter
    
    init(hospitalId: Int, account: String, token: String, fcmToken: String, appManager: NavigationRouter) {
        self.hospitalId = hospitalId
        self.account = account
        self.token = token
        self.fcmToken = fcmToken
        self.appManager = appManager
    }
    
    
    func returnSocketURL() throws -> URL{
        do{
            var urlComponents = URLComponents(string: try UtilityURLReturn.SOCKET_SERVER())
            urlComponents?.path = "/ws"
            let queryItems = [
                URLQueryItem(name: "access_token", value: token),
                URLQueryItem(name: "uid", value: UserVariable.GET_UUID()),
                URLQueryItem(name: "service_id", value: "1"),
                URLQueryItem(name: "fcm_token", value: fcmToken),
                URLQueryItem(name: "hospital_id", value: String(hospitalId))
            ]
            urlComponents?.queryItems = queryItems
            guard let url = urlComponents?.url else{
                throw TraceUserError.clientError("returnSocketURL")
            }
            return url
        }catch{
            throw error
        }
    }
    
    func returnStringToArray(jsonString: String) -> (success: Bool,arr: [String]){
        guard let jsonData = jsonString.data(using: .utf8) else{
            return (false,[])
        }
        do{
            let decoder = JSONDecoder()
            let stringArray = try decoder.decode([String].self, from: jsonData)
            return (true,stringArray)
        }catch{
            print("초기 이미지 스트링 변환 실패 \(error)")
            return (false,[])
        }
    }
    
    func sendMessage(
        msg_type: Int,
        from: String,
        to: String,
        content_type: String,
        message: String? = nil,
        file_cnt: Int? = nil,
        file_ext: [String]? = nil,
        file_name: [String]? = nil
    ) async -> Bool {
        let content = createMessageContent(
            message: message,
            file_cnt: file_cnt,
            file_ext: file_ext,
            file_name: file_name
        )
        
        guard let chatMessage = createChatMessage(
            msg_type: msg_type,
            from: from,
            to: to,
            content_type: content_type,
            content: content
        ) else {
            print("ChatMessage 생성 실패")
            return false
        }
        
        guard let jsonString = encodeMessageToJSON(chatMessage) else {
            print("JSON 문자열 변환 실패")
            return false
        }
        
        return await sendWebSocketMessage(jsonString)
    }
    
    private func createMessageContent(
        message: String?,
        file_cnt: Int?,
        file_ext: [String]?,
        file_name: [String]?
    ) -> SendChatDataModel.MessageContent {
        return SendChatDataModel.MessageContent(
            message: message,
            file_cnt: file_cnt,
            file_ext: file_ext,
            file_name: file_name
        )
    }
    
    private func createChatMessage(
        msg_type: Int,
        from: String,
        to: String,
        content_type: String,
        content: SendChatDataModel.MessageContent
    ) -> SendChatDataModel.ChatMessageContent? {
        switch msg_type {
        case 2:
            return SendChatDataModel.ChatMessageContent(
                msg_type: 2,
                from: from,
                to: to
            )
        default:
            return SendChatDataModel.ChatMessageContent(
                msg_type: 3,
                from: from,
                to: to,
                content_type: content_type,
                content: content
            )
        }
    }
    
    private func encodeMessageToJSON(_ chatMessage: SendChatDataModel.ChatMessageContent) -> String? {
        guard let jsonData = try? JSONEncoder().encode(chatMessage) else {
            print("JSON 인코딩 실패")
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }
    
    private func sendWebSocketMessage(_ jsonString: String) async -> Bool {
        let message = URLSessionWebSocketTask.Message.string(jsonString)
        return await withCheckedContinuation { continuation in
            webSocketTask?.send(message) { error in
                if let error = error {
                    DispatchQueue.main.async{
                        self.appManager.displayError(ServiceError: .clientError(error.localizedDescription))
                    }
                } else {
                    print("✅ 메시지 전송 성공")
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    
}
