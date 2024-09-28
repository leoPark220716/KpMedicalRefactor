//
//  ChatHandler.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/26/24.
//

import Foundation

class ChatHandler: ChatDataHandler{
    // 소켓연결을 확장해서 기본 데이터 세팅
    
    override func Connect() async {
        await super.Connect()
        setupMessageReceiver()
        do {
            let checkExist = try await requsetCheckRoomExist()
            chatRoomInfoSetUp(state: checkExist.exist, chatId: checkExist.chatId)
            print("👀 check HaveToCreateRoom state : \(HaveToCreateRoom)")
            guard checkExist.exist else { return }
            let success = await sendMessage(msg_type: 2, from: account, to: String(hospitalId), content_type: "text")
            print("👀 message observe success : \(success)")
            guard ChatData.isEmpty else { return }
            try await loadChatData()
            
        } catch {
            await appManager.displayError(ServiceError: error)
        }
    }
    
    private func setupMessageReceiver() {
        super.onMessageReceived = { [weak self] message in
            guard let self = self else { return }
            let jsonMessage = UpdateChatList(ReciveText: message)
            guard let jsonData = jsonMessage.jsonData else { return }
            MethodCall(jsonData: jsonData)
        }
        super.receiveMessage()
    }
    
    private func loadChatData() async throws {
        let redisChatData = try await requsetGetRedisChatDatas(chatId: chatId)
        lastChatTime = redisChatData.array.last?.timestamp_uuid
        hospitalTime = redisChatData.hospitalTime
        let redisDataSet = getByHttpChatDataHandler(decodedData: redisChatData.array)
        let chatData = Array(redisDataSet.reversed())
        await appendHttpChatDataArray(appnedData: chatData)
        guard redisDataSet.count >= 29 else {
            try await loadDynamoChatData()
            return
        }
    }
    
    private func loadDynamoChatData() async throws {
        print("👀 loadDynamoChatData")
        let dynamoChatData = try await requsetGetDbChatDatas(chatId: chatId, query: "limit=30&service_id=1")
        lastChatTime = dynamoChatData.last?.timestamp_uuid
        let dynamoChatSet = getByHttpChatDataHandler(decodedData: dynamoChatData)
        let chatData = Array(dynamoChatSet.reversed())
        await appendHttpChatDataArray(appnedData: chatData)
    }
    func createChatRoom() async {
        let create = await requestCreateRoom()
        HaveToCreateRoom = !create.create
        let success = await sendMessage(msg_type: 2, from: account, to: String(hospitalId), content_type: "text")
        print("👀 messege observe success : \(success)")
    }
    func goToPhotoView(item: ChatHandlerDataModel.ChatMessegeItem){
        print(item)
        if item.type == .photo, let imageArray = item.ImageArray{
            let images = ImagesSepView(Images: imageArray)
            DispatchQueue.main.async {
                self.appManager.push(to: .userPage(item: UserPage(page: .images),images: images))
            }
        }
    }
    func pageNationChatDataGet(){
        print("👀 page pageNationChatDataGet")
        var queryString: String {
            var components = URLComponents()
            components.queryItems = [
                URLQueryItem(name: "timestamp_uuid", value: lastChatTime),
                URLQueryItem(name: "limit", value: "30"),
                URLQueryItem(name: "service_id", value: "1"),
            ].filter { $0.value != nil } // nil 값 필터링
            // URLComponents를 통해 안전하게 URL 생성
            return components.url?.query ?? ""
        }
        Task{
            guard lastChatTime != nil else { return }
            let dynamoChatData = try await requsetGetDbChatDatas(chatId: chatId, query: queryString)
            lastChatTime = dynamoChatData.last?.timestamp_uuid
            let dynamoChatSet = getByHttpChatDataHandler(decodedData: dynamoChatData)
            await appendHttpChatDataArray(appnedData: dynamoChatSet)
        }
    }
    
    // 기본 데이터 세팅
    private func chatRoomInfoSetUp(state: Bool, chatId: Int){
        self.HaveToCreateRoom = !state
        self.chatId = chatId
    }
    
    
    @MainActor
    private func appendHttpChatDataArray(appnedData: [ChatHandlerDataModel.ChatMessegeItem]){
        if let firstMatch = appnedData.first(where: { $0.amI == .sepDate }){
            ChatData.removeAll { existingItem in
                existingItem.amI == .sepDate && existingItem.chatDate == firstMatch.chatDate
            }
        }
        
        // 새로운 데이터를 추가합니다.
        ChatData.append(contentsOf: appnedData)
    }
    
    // 사진전송 전 로딩 화면 세팅
    func setpPreChatItem(){
        let itemType = ChatHandlerDataModel.ChatMessegeItem.MessageTypes.photo
        let item =  textMessageItem(type: itemType, time: "", date: "", amI: ChatHandlerDataModel.ChatMessegeItem.AmI.user, unix: 0,progress: true)
        DispatchQueue.main.async {
            self.ChatData.insert(item, at: 0)
        }
    }
    // 사진 전송
    func sendImageStart(){
        let file_ext =  Array(repeating: ".png", count: SendingImages.count)
        let file_name = Array(repeating: "1", count: SendingImages.count)
        Task{
            let success = await sendImages(extend: file_ext, name: file_name, imagesCount: SendingImages.count, SendingImagesByte: SendingImagesByte)
            if success{
                await cleanImageDatas()
            }
        }
        
    }
    //     메시지 전송
    func sendTextMessege(chatText: String)  {
        Task{
            let success = await sendMessage(msg_type: 3, from: account, to: String(hospitalId), content_type: "text",message: chatText)
            print("👀 Text메시지 전송 : \(success)")
            
        }
    }
    override func disconnect() {
        isActiveOnChatView = false
        super.disconnect()
    }
    // 트랜잭션 성공 메시지
    func sendTransactionConfirm(message: String, blockHash: String) async -> Bool{
        let msg = SendChatDataModel.content(message: message)
        let hash = SendChatDataModel.blockData(hash: blockHash)
        let content = SendChatDataModel.Confirmed(msg_type: 9, from: account, to: String(hospitalId), content_type: "text",content: msg,block_data: hash)
        guard let jsonData = try? JSONEncoder().encode(content) else{
            return false
        }
        guard let jsonString = String(data: jsonData, encoding: .utf8) else{
            return false
        }
        let message = URLSessionWebSocketTask.Message.string(jsonString)
        return await withCheckedContinuation { continuation in
            webSocketTask?.send(message, completionHandler: { Error in
                if let err = Error {
                    print("❌ sendTransactionConfirm Message Sending Err \(err.localizedDescription)")
                    continuation.resume(returning: false)
                }else{
                    print("✅ sendTransactionConfirm SendSuccess")
                    continuation.resume(returning: true)
                }
            })
        }
    }
    
    @MainActor
    func cleanImageDatas(){
        SendingImages.removeAll()
        SendingImagesByte.removeAll()
    }
    
    
    
    func handleBackButton(){
        Task{
            isActiveOnChatView = false
            _ = await sendMessage(msg_type: 2, from: account, to: String(hospitalId), content_type: "text",message: "")
            disconnect()
            await appManager.goBack()
            
        }
    }
}
