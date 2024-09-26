//
//  UserConfigVariable.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/11/24.
//

import Foundation
import UIKit


enum UserVariable {
    static func AuthVal(for key: String) throws -> String {
        if let config = Bundle.main.object(forInfoDictionaryKey: "Config") as? [String: String],
           let apiDomain = config[key] {
            return "\(apiDomain)_auth_"
        } else {
            throw TraceUserError.configError("\(PlistManager.shared.string(forKey: "configError")) \(key)")
        }
    }
    static func ConfigVal(for key: String) throws -> String {
        if let config = Bundle.main.object(forInfoDictionaryKey: "Config") as? [String: String],
           let apiDomain = config[key] {
            return apiDomain
        } else {
            throw TraceUserError.configError("\(PlistManager.shared.string(forKey: "configError")) \(key)")
        }
    }
    static func FOR_USER_AUTH() throws -> String {
        return try AuthVal(for: "APP_IDENTIFY")
    }
    static func TOAST_LOGIN_FAIL() throws -> String {
        return try ConfigVal(for: "LOGIN_FAIL")
    }
    static func GET_UUID() -> String {
        print("✅ UUID : \(UIDevice.current.identifierForVendor!.uuidString)")
        return UIDevice.current.identifierForVendor!.uuidString
    }
    static func NAVER_MAP_API() throws -> String {
        return try ConfigVal(for: "X_NCP_APIGW_API_KEY")
    }
    static func NAVER_MAP_API_ID() throws -> String {
        return try ConfigVal(for: "X_NCP_APIGW_API_KEY_ID")
    }
    static func CBC_NONCE() throws -> String {
        return try ConfigVal(for: "CBC_NONCE")
    }
    static func MANAGER_ACCOUNT() throws -> String {
        return try ConfigVal(for: "MANAGER_ACCOUNT")
    }
    static func APP_VERSION() -> String {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return appVersion
        }
        return "No Version"
    }
}
