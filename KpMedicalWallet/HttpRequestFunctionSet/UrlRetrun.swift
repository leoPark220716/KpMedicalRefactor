//
//  UrlRetrun.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation
import UIKit

enum UtilityURLReturn {
    static func serverURL(for key: String, defaultURL: String = "api_domain") -> String {
        if let config = Bundle.main.object(forInfoDictionaryKey: "Config") as? [String: String],
           let apiDomain = config[key] {
            return apiDomain
        } else {
            return defaultURL
        }
    }

    static func API_SERVER() -> String {
        return serverURL(for: "API_SERVER")
    }
    static func BLOCKCHAIN_SERVER() -> String {
        return serverURL(for: "BLOCKCHAIN_DOMAIN")
    }

    static func SOCKET_SERVER() -> String {
        return serverURL(for: "WEB_SOCKET")
    }
    static func LOCATION_WALLET() -> String {
        return serverURL(for: "URL_LOCATION_WALLET")
    }
    static func LOCATION_COMMON() -> String {
        return serverURL(for: "URL_LOCATION_COMMON")
    }
}

enum UserVariable {
    
    static func ConfigVal(for key: String, defaultURL: String = "NULL") -> String {
        if let config = Bundle.main.object(forInfoDictionaryKey: "Config") as? [String: String],
           let apiDomain = config[key] {
            return "\(apiDomain)_auth_"
        } else {
            return defaultURL
        }
    }
    static func FOR_USER_AUTH() -> String {
        return ConfigVal(for: "APP_IDENTIFY")
    }
    static func GET_UUID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
}
