//
//  ChatModel.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/26/24.
//

import Foundation
struct ChatHTTPresponseStruct{
    
    struct ChatList: Codable{
        var chats: [ChatListArray]
        var error_code: Int
        var error_stack: String
    }
    struct ChatListArray: Codable {
        var chat_id: Int
        var hospital_id:Int
        var hospital_name: String
        var icon: String
        var patient_id:String
        var patient_name:String
        var room_key: String
        var last_connected_time: String
        var unread_cnt: Int
        var last_message: LastMessage
    }
    struct LastMessage: Codable{
        var timestamp: String
        var message: String
    }
    
    
    // 메시지와 관련된 데이터를 포함하는 구조체
    struct MessageData: Codable {
        var messages: [Chat_Message]
        var chat_info: chatInfo?
        var error_code: Int
        var error_stack: String
    }
    struct CreateResponse: Codable{
        var chat_id: Int
        var error_code: Int
        var error_stack: String
    }
    struct PatchTimeResponse: Codable{
        var affectedRows: Int
        var error_code: Int
        var error_stack: String
    }
    struct chatInfo: Codable{
        var chat_id: Int
        var hospital_id: Int
        var patient_id: String
        var h_connected_time:String
        var p_connected_time:String
        var icon: String
    }
    // 개별 메시지 구조체
    struct Chat_Message: Codable {
        var room_key: String?
        var timestamp_uuid: String?
        var uuid: String?
        var msg_type: Int
        var from: String
        var to: String
        var content_type: String
        var message: String
        var file_cnt: Int
        var bucket: [String]
        var key: [String]
        var hospital_id: Int
        var unixtime: Int?
        var index: Int
        var pub_key: String
        var hash: String
        var timestamp: String
        var status: Int
        var department_code: Int
        
    }
    struct JoinRoom: Codable{
        var service_id: Int
        var hospital_id: Int
    }
    struct PatchChatTime: Codable{
        var service_id: Int
        var room_key: String
    }
}
struct ChatHandlerDataModel{
    struct ChatMessegeItem: Codable{
        var type: MessageTypes
        var messege: String?
        var ReadCount: Bool
        var FileURI: String?
        var time: String
        var amI: AmI
        var chatDate: String
        var showETC: Bool
        var ImageArray: [URL]?
        var progress: Bool
        var unixTime: Int
        var noticeMsgNine = false
        var hash: String?
        var departmentCode: Int?
        var pubKey: String?
        var index: Int?
        var status: String?
        var timeStemp: String?
        enum AmI: Codable{
            case user, other, sepDate
        }
        enum MessageTypes: Codable{
            case text, photo, file, notice, share,edit, unowned
        }
    }

}
struct OpenChatRoomDataModel{
    struct ChatMessage: Codable {
        var msg_type: Int
        var from: String
        var to: String
        var content_type: String
        var content: MessageContent?
        var block_data: BlockData?
        var hospital_data: HospitalData?
        var on: Bool
        var err_msg: String?
        var timestamp: String?
    }
    
    struct MessageContent: Codable {
        var message: String
        var file_cnt: Int?
        var file_name: [String]?
        var file_ext: [String]?
        var file_size: [Int]?
        var bucket: KeyType?
        var key: KeyType?
    }
    
    struct BlockData: Codable {
        var hospital_id: Int
        var unixtime: Int?
        var index: Int?
        var pub_key: String?
        var hash: String?
        var department_code: Int?
    }
    
    struct HospitalData: Codable {
        var old_room_id: Int
        var room_id: Int
        var room_name: String?
        var patient_no: Int
        var user_id: String?
        var contract: String?
        var patient_name: String?
        var dob: String?
        var sex_code: String?
        var purpose: String?
        var status: Int
        var all_status: [String: ChatDetail]?
        var timestamp: String?
    }
    
    struct ChatDetail: Codable {
        var bucket: KeyType?
        var chat_index: String
        var content_type: String
        var file_cnt: String
        var from: String
        var hospital_id: String
        var index: String
        var key: KeyType?
        var message: String
        var msg_type: String
        var pub_key: String?
        var timestamp: String
        var to: String
        var unixtime: Int?
        var uuid: String
        var hash: String?
    }
    enum KeyType: Codable {
        case string(String)
        case array([String])
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let string = try? container.decode(String.self) {
                self = .string(string)
            } else if let array = try? container.decode([String].self) {
                self = .array(array)
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected String or [String]")
            }
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .string(let string):
                try container.encode(string)
            case .array(let array):
                try container.encode(array)
            }
        }
    }
}
struct SendChatDataModel{
    struct ChatMessageContent: Codable {
        var msg_type: Int
        var from: String
        var to: String?
        var content_type: String?
        var content: MessageContent?
    }
    struct MessageContent: Codable{
        var message: String?
        var file_cnt: Int?
        var file_ext: [String]?
        var file_name: [String]?
    }
    struct Confirmed: Codable {
        let msg_type: Int
        let from: String
        let to: String
        let content_type: String
        let content: content
        let block_data: blockData
    }
    struct content: Codable{
        let message: String
    }
    struct blockData: Codable{
        let hash: String
    }
}
