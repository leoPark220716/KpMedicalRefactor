//
//  HttpError.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/11/24.
//

import Foundation


enum TraceUserError: Error {
    case noConnection(String)
    case serverError(String)
    case clientError(String)
    case jsonParseError(String)
    case userError(String)
    case blockChainError(String)
    case configError(String)
    case authData(String)
    case unowned(String)
    case managerFunction(String)
    case httpRequestError(String)
}

extension TraceUserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noConnection(_):
            return PlistManager.shared.string(forKey: "error_no_connection")
        case .serverError(_):
            return PlistManager.shared.string(forKey: "error_server")
        case .clientError(_):
            return PlistManager.shared.string(forKey: "error_client")
        case .jsonParseError(_):
            return PlistManager.shared.string(forKey: "error_json_parse")
        case .userError(_):
            return PlistManager.shared.string(forKey: "error_user")
        case .blockChainError(_):
            return PlistManager.shared.string(forKey: "error_blockchain")
        case .configError(_):
            return PlistManager.shared.string(forKey: "error_config")
        case .authData(_):
            return PlistManager.shared.string(forKey: "error_auth_data")
        case .unowned(_):
            return PlistManager.shared.string(forKey: "error_unowned")
        case .managerFunction(_):
            return PlistManager.shared.string(forKey: "managerFunction")
        case .httpRequestError(_):
            return PlistManager.shared.string(forKey: "error_http_request")
        }
    }
    var recoverySuggestion: String? {
        switch self {
        case .noConnection(_):
            return PlistManager.shared.string(forKey: "suggestion_no_connection")
        case .serverError(_):
            return PlistManager.shared.string(forKey: "suggestion_server_error")
        case .clientError(_):
            return PlistManager.shared.string(forKey: "suggestion_client_error")
        case .jsonParseError(_):
            return PlistManager.shared.string(forKey: "suggestion_json_parse_error")
        case .userError(let detailError):
            return detailError // 사용자 정의 오류 메시지는 그대로 사용
        case .blockChainError(_):
            return PlistManager.shared.string(forKey: "suggestion_blockchain_error")
        case .configError(_):
            return PlistManager.shared.string(forKey: "suggestion_config_error")
        case .authData(_):
            return PlistManager.shared.string(forKey: "suggestion_auth_data_error")
        case .unowned(_):
            return PlistManager.shared.string(forKey: "suggestion_unowned_error")
        case .managerFunction(let detailError):
            return detailError
        case .httpRequestError(_):
            return PlistManager.shared.string(forKey: "suggestion_http_request_error")
        }
    }
    
}





