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
    func requestCreateRoom() async -> (create: Bool, chatId: Int){
        do{
            let request = createChatRoomRequest()
            let call = KPWalletAPIManager(httpStructs: request, URLLocations: 2)
            let response = try await call.performRequest()
            if response.success, let data = response.data?.data{
                return (create: true,chatId: data.chat_id)
            }else{
                await appManager.displayError(ServiceError: .clientError("❌ requestCreateRoom"))
            }
            return (create: false,chatId: 0)
        }catch{
            await appManager.displayError(ServiceError: error)
            return (create: false,chatId: 0)
        }
    }
    
    
    
    func requsetGetRedisChatDatas(chatId: Int) async throws -> (array: [ChatHTTPresponseStruct.Chat_Message],hospitalTime: String) {
        do{
            let requset = createGetRedisChatDatas(chatId: chatId)
            let call = KPWalletAPIManager(httpStructs: requset, URLLocations: 2)
            let response = try await call.performRequest()
            if response.success, let data = response.data?.data{
                return (array:data.messages,hospitalTime:data.chat_info?.h_connected_time ?? "")
            }
            throw TraceUserError.serverError("requsetGetChatDatas")
        }catch{
            throw error
        }
    }
    func requsetGetDbChatDatas(chatId: Int,query: String) async throws -> [ChatHTTPresponseStruct.Chat_Message] {
        do{
            let requset = createGetDBChatDatas(chatId: chatId,query: query)
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
    func createGetRedisChatDatas(chatId: Int) -> http<Empty?, KPApiStructFrom<ChatHTTPresponseStruct.MessageData>>{
        return http(method: "GET", urlParse: "v2/chat/\(chatId)?service_id=1", token: token, UUID: UserVariable.GET_UUID())
    }
    // 채팅방 채팅 리스트 패이지네이션
    func createGetDBChatDatas(chatId: Int,query: String) -> http<Empty?, KPApiStructFrom<ChatHTTPresponseStruct.MessageData>>{
        return http(method: "GET", urlParse: "v2/chat/\(chatId)/messages?\(query)", token: token, UUID: UserVariable.GET_UUID())
    }
    // 채팅방 생성
    func createChatRoomRequest()-> http<ChatHTTPresponseStruct.JoinRoom?, KPApiStructFrom<ChatHTTPresponseStruct.CreateResponse>>{
        let body = ChatHTTPresponseStruct.JoinRoom(
            service_id: 1, hospital_id: hospitalId
        )
        return http(method: "POST", urlParse: "v2/chat", token: token, UUID: UserVariable.GET_UUID(),requestVal: body)
    }
    // 채팅방 존재여부 확인 요청값 리턴
    func createGetChatRoomExist() -> http<Empty?, KPApiStructFrom<ChatHTTPresponseStruct.CreateResponse>>{
        return http(method: "GET", urlParse: "v2/chat/room?service_id=1&hospital_id=\(hospitalId)", token: token ,UUID: UserVariable.GET_UUID())
    }
}
