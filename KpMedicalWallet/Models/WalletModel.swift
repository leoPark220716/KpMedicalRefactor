//
//  WalletModel.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/23/24.
//

struct WalletModel{
    struct SaveContract: Codable{
        let access_token: String
        let uid: String
        let contract: String
    }
    struct SaveContractResponseData: Codable{
        let access_token: String
        let affected_rows: Int
        let error_code: Int
        let error_stack: String
    }
    
    
    struct SaveWalletData: Codable{
        let access_token: String
        let uid: String
        let address: String
        let encrypt_rsa: String
        let type: Int
    }
    
    struct WalletInfomationResponse: Codable{
        let access_token: String
        let encrypt_rsa: String
        let address: String?
        let contract: String?
        let error_code: Int
        let error_stack: String
    }
    struct AccessItem{
        let HospitalName: String
        let Purpose: String
        let State: Bool
        let Date: String
        let blockHash: String
        let unixTime: Int
        let room_key: String
        let msg_type: String
        let timestamp_uuid: String
    }
    
    
    
    
    
    struct TransactionItems: Codable{
        let room_key: String
        let timestamp_uuid: String
        let msg_type: Int
        let from: String
        let to: String
        let content_type: String
        let message: String
        let file_cnt: Int
        let bucket: [String]
        let key: [String]
        let hospital_id: Int
        let unixtime: Int
        let index: Int
        let pub_key: String
        let hash: String
        let status: Int
        let timestamp: String
        let hospital_name: String
    }
    struct getListData: Codable{
        let transactions: [TransactionItems]
        let error_code: Int
        let error_stack: String
    }
    
}
