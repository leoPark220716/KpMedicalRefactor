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
        guard let lastItem = ChatData.last, let timeStemp = lastItem.timeStemp else { return }
        let dynamoChatData = try await requsetGetDbChatDatas(chatId: chatId, query: "timestamp_uuid=\(timeStemp)&limit=30&service_id=1")
        let dynamoChatSet = getByHttpChatDataHandler(decodedData: dynamoChatData)
        let chatData = Array(dynamoChatSet.reversed())
        await appendHttpChatDataArray(appnedData: chatData)
    }
    // ㅇㅇㅇㅇ
    
    func createChatRoom() async {
        let create = await requestCreateRoom()
        HaveToCreateRoom = !create.create
        let success = await sendMessage(msg_type: 2, from: account, to: String(hospitalId), content_type: "text")
        print("👀 messege observe success : \(success)")
    }
    func goToPhotoView(item: ChatHandlerDataModel.ChatMessegeItem){
        if item.type == .photo, let imageArray = item.ImageArray{
            let images = ImagesSepView(Images: imageArray)
            DispatchQueue.main.async {
                self.appManager.push(to: .userPage(item: UserPage(page: .images),images: images))
            }
        }
    }
    func pageNationChatDataGet(){
        Task{
            guard let lastItem = ChatData.last, let timeStemp = lastItem.timeStemp else {
                return
            }
            print("👀 timestamp_uuid \(timeStemp)")
            let dynamoChatData = try await requsetGetDbChatDatas(chatId: chatId, query: "timestamp_uuid=\(timeStemp)&limit=30&service_id=1")
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
    @MainActor
    func cleanImageDatas(){
        SendingImages.removeAll()
        SendingImagesByte.removeAll()
    }

    
    //     메시지 전송
    func sendTextMessege(chatText: String)  {
        Task{
            let success = await sendMessage(msg_type: 3, from: account, to: String(hospitalId), content_type: "text",message: chatText)
            print("👀 Text메시지 전송 : \(success)")
            
        }
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
