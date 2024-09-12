//
//  UrlRetrun.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/10/24.
//

import Foundation

enum UtilityURLReturn {
    static func serverURL(for key: String) throws -> String {
        if let config = Bundle.main.object(forInfoDictionaryKey: "Config") as? [String: String],
           let apiDomain = config[key] {
            return apiDomain
        } else {
            throw TraceUserError.configError("\(PlistManager.shared.string(forKey: "configError")) \(key)")
        }
    }
    static func API_SERVER() throws -> String {
        return try serverURL(for: "API_SERVER")
    }
    static func BLOCKCHAIN_SERVER() throws -> String {
        return try serverURL(for: "BLOCKCHAIN_DOMAIN")
    }
    static func SOCKET_SERVER() throws -> String {
        return try serverURL(for: "WEB_SOCKET")
    }
    static func LOCATION_WALLET() throws -> String {
        return try serverURL(for: "URL_LOCATION_WALLET")
    }
    static func LOCATION_COMMON() throws -> String {
        return try serverURL(for: "URL_LOCATION_COMMON")
    }
}

