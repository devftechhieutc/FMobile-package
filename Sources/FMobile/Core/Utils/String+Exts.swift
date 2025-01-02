//
//  File 2.swift
//  FMobile
//
//  Created by Tran Hieu on 14/11/24.
//

import Foundation
import CryptoKit
import CommonCrypto


extension String {
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    var isBlank: Bool {
        return self.trim().isEmpty
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func removeAllWhitespaces() -> String {
        return components(separatedBy: .whitespacesAndNewlines).joined(separator: "")
    }
    
    func lowercasedAndRemoveSpaces() -> String {
        return self.lowercased().replacingOccurrences(of: " ", with: "").trim()
    }
    
    func decodeBase64() -> String? {
        var decodedString = ""
        if let decodedData = Data(base64Encoded: self) {
            decodedString = String(data: decodedData, encoding: .utf8)!
        }

        if !decodedString.isEmpty {
            return decodedString
        } else {
            return nil
        }
    }
    
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    
    func md5() -> String {
        let digest = Insecure.MD5.hash(data: Data(self.utf8))

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
