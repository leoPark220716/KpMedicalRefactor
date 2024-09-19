//
//  PlistManager.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/12/24.
//

import Foundation

class PlistManager {
    static let shared = PlistManager()
    
    private var strings: [String: String] = [:]
    
    private init() {
        loadPlist()
    }
    
    private func loadPlist() {
        if let url = Bundle.main.url(forResource: "Strings", withExtension: "plist"),
           let data = try? Data(contentsOf: url) {
            do {
                if let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: String] {
                    strings = plist
                }
            } catch {
                print("Error reading plist: \(error)")
            }
        }
    }
    func string(forKey key: String) -> String {
        print("✅ errorMessageKey : \(key)")
        return strings[key] ?? "Key not found"
    }
}

