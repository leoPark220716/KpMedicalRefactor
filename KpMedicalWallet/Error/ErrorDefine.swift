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
            return "No connection"
        case .serverError(_):
            return "Server error"
        case .clientError(_):
            return "Client error"
        case .jsonParseError(_):
            return "JSON parse error"
        case .userError(_):
            return "User error"
        case .blockChainError(_):
            return "Blockchain error"
        case .configError(_):
            return "Configuration error"
        case .authData(_):
            return "Authentication data error"
        case .unowned(_):
            return "Unowned error"
        case .managerFunction(_):
            return "Manager function error"
        case .httpRequestError(_):
            return "HTTP request error"
        }
    }
    var recoverySuggestion: String? {
        switch self {
        case .noConnection(_):
            return "인터넷에 연결해주세요"
        case .serverError(_):
            return "불편을 끼쳐드려서 죄송합니다. 해당 내용을 보고하기 위해 서비스 이용 기록을 저장하는 것에 동의하십니까?r"
        case .clientError(_):
            return "불편을 끼쳐드려서 죄송합니다. 해당 내용을 보고하기 위해 서비스 이용 기록을 저장하는 것에 동의하십니까?"
        case .jsonParseError(_):
            return "JSON 불편을 끼쳐드려서 죄송합니다. 해당 내용을 보고하기 위해 서비스 이용 기록을 저장하는 것에 동의하십니까?"
        case .userError(let detailError):
            return "\(detailError)"
        case .blockChainError(_):
            return "불편을 끼쳐드려서 죄송합니다. 해당 내용을 보고하기 위해 서비스 이용 기록을 저장하는 것에 동의하십니까?"
        case .configError(_):
            return "불편을 끼쳐드려서 죄송합니다. 해당 내용을 보고하기 위해 서비스 이용 기록을 저장하는 것에 동의하십니까?"
        case .authData(_):
            return "불편을 끼쳐드려서 죄송합니다. 해당 내용을 보고하기 위해 서비스 이용 기록을 저장하는 것에 동의하십니까?"
        case .unowned(_):
            return "불편을 끼쳐드려서 죄송합니다. 해당 내용을 보고하기 위해 서비스 이용 기록을 저장하는 것에 동의하십니까?"
        case .managerFunction(_):
            return "불편을 끼쳐드려서 죄송합니다. 해당 내용을 보고하기 위해 서비스 이용 기록을 저장하는 것에 동의하십니까?"
        case .httpRequestError(_):
            return "불편을 끼쳐드려서 죄송합니다. 해당 내용을 보고하기 위해 서비스 이용 기록을 저장하는 것에 동의하십니까?"
        }
    }
}
enum MyErrorDomain: String {
    case constructURL = "constructURL"
    case configureRequest = "configureRequest"
    case performRequest = "performRequest"
    case handleResponse = "handleResponse"
    case jsonParseError = "jsonParseError"
    case authData = "keyChain authData"
    
    case noConnection = "noConnection"
    case serverError = "serverError"
    case clientError = "clientError"
    case userError = "userError"
    case LoginCheck = "LoginCheck"
    case blockChainError = "blockChainError"
    case urlFail = "Create URL Fail"
    case configError = "Config String Error"
    case ErrorUnknown = "An unknown error occurre"
    case userAuthSave = "userAuthSave"
    case userLoadAuthData = "userLoadAuthData"
}





//return NSLocalizedString("불편을 끼쳐드려서 죄송합니다. 해당 내용을 보고하기 위해 서비스 이용 기록을 저장하는 것에 동의하십니까?", comment: "")
