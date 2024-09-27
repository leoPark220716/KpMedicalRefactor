//
//  Untitled.swift
//  KpMedicalWallet
//
//  Created by Junsung Park on 9/23/24.
//
import Foundation
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
extension Data {
    func isPNG() -> Bool {
        let pngSignatureBytes: [UInt8] = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]
        var header = [UInt8](repeating: 0, count: 8)
        self.copyBytes(to: &header, count: 8)
        return header == pngSignatureBytes
    }
}
