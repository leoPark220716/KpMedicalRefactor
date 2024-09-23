//
//  Untitled.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/23/24.
//
extension String {
    var hexaBytes: [UInt8]? {
        var bytes = [UInt8]()
        var startIndex = index(startIndex, offsetBy: 0)
        
        while startIndex < endIndex {
            let endIndex = index(startIndex, offsetBy: 2, limitedBy: endIndex) ?? endIndex
            let hexStr = String(self[startIndex..<endIndex])
            if let byte = UInt8(hexStr, radix: 16) {
                bytes.append(byte)
            } else {
                return nil
            }
            startIndex = endIndex
        }
        return bytes
    }
}
