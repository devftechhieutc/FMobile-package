//
//  File.swift
//  FMobile
//
//  Created by Tran Hieu on 13/11/24.
//

import Foundation
import UIKit

extension Dictionary {
    public func toJson(beautify: Bool = false) -> String? {
        guard let data = try? JSONSerialization.data(
            withJSONObject: self,
            options: beautify ? .prettyPrinted : .init()) else {
                return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}
