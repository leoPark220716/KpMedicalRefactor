//
//  ChatHandler.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/26/24.
//

import Foundation

class ChatHandler: ChatDataHandler{
    var HaveToCreateRoom: Bool = false
    var chatId: Int = 0
    
    
    // 소켓연결을 확장해서 기본 데이터 세팅
    override func Connect() async {
        await super.Connect()
        // 소켓 리시버 메시지 전달
        super.onMessageReceived = { [weak self] message in
            guard let self = self else { return }
            let jsonMessage = UpdateChatList(ReciveText: message)
            guard let jsonData = jsonMessage.jsonData else{
                return
            }
            MethodCall(jsonData: jsonData)
        }
        super.receiveMessage()
        do{
            let checkExist = try await requsetCheckRoomExist()
            chatRoomInfoSetUp(state: checkExist.exist, chatId: checkExist.chatId)
            print("👀 check HaveToCreateRoom state : \(HaveToCreateRoom)")
            if !checkExist.exist{
                return
            }
            let success = await sendMessage(msg_type: 2, from: account, to: String(hospitalId), content_type: "text")
            print("👀 messege observe success : \(success)")
            let redisChatData = try await requsetGetChatDatas(chatId: chatId)
            let resdisDataSet = getByHttpChatDataHandler(decodedData: redisChatData)
            await appendHttpChatDataArray(appnedData: resdisDataSet)
        }catch{
            await appManager.displayError(ServiceError: error)
        }
    }
    
    // 기본 데이터 세팅
    private func chatRoomInfoSetUp(state: Bool, chatId: Int){
        self.HaveToCreateRoom = !state
        self.chatId = chatId
    }
    
    @MainActor
    private func appendHttpChatDataArray(appnedData: [ChatHandlerDataModel.ChatMessegeItem]){
        ChatData = Array(appnedData.reversed())
    }
    

    
    //     메시지 전송
    func sendTextMessege(chatText: String)  {
        Task{
            let success = await sendMessage(msg_type: 3, from: account, to: String(hospitalId), content_type: "text",message: chatText)
            print("👀 Text메시지 전송 : \(success)")
        }
    }
}
