//
//  SoketHttpRequest.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/26/24.
//

import Foundation

class SocketHttpRequest: Socket{
    
    // 채팅방 존재여부 확인 요청
    func requsetCheckRoomExist() async throws -> (exist: Bool, chatId: Int){
        do{
            let request = createGetChatRoomExist()
            let call = KPWalletAPIManager(httpStructs: request, URLLocations: 2)
            let response = try await call.performRequest()
            if response.success, let data = response.data?.data{
                if data.chat_id != -1 {
                    return (exist:true, chatId: data.chat_id)
                }else{
                    return (exist:false, chatId: data.chat_id)
                }
            }
            throw TraceUserError.serverError("❌ requsetCheckRoomExist")
        }catch{
            throw error
        }
    }
    // 채팅방 존재여부 확인 요청값 리턴
    func createGetChatRoomExist() -> http<Empty?, KPApiStructFrom<ChatHTTPresponseStruct.CreateResponse>>{
        return http(method: "GET", urlParse: "v2/chat/room?service_id=1&hospital_id=\(hospitalId)", token: token ,UUID: UserVariable.GET_UUID())
    }
    
    func requsetGetChatDatas(chatId: Int) async throws -> [ChatHTTPresponseStruct.Chat_Message] {
        do{
            let requset = createGetChatDatas(chatId: chatId)
            let call = KPWalletAPIManager(httpStructs: requset, URLLocations: 2)
            let response = try await call.performRequest()
            if response.success, let data = response.data?.data{
                return data.messages
            }
            throw TraceUserError.serverError("requsetGetChatDatas")
        }catch{
            throw error
        }
    }
    // 채팅방 데이터 조회
    func createGetChatDatas(chatId: Int) -> http<Empty?, KPApiStructFrom<ChatHTTPresponseStruct.MessageData>>{
        return http(method: "GET", urlParse: "v2/chat/\(chatId)?service_id=1", token: token, UUID: UserVariable.GET_UUID())
    }
    
}
