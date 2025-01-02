//
//  File.swift
//  
//
//  Created by Ishipo on 11/8/24.
//

import Foundation
import UIKit

extension UIColor {
    static var primary: UIColor = .clear
    static var hyperLink: UIColor = .clear
    static var gradientStartPrimary: UIColor = .clear
    static var gradientEndPrimary: UIColor = .clear
    static var disable: UIColor = .clear
    static var textPrimary: UIColor = .clear
    static var textSecondary: UIColor = .clear
    static var textHint: UIColor = .clear
    static var backgroundPrimary: UIColor = .clear
    static var success: UIColor = .clear
    static var divider: UIColor = .clear
    static var error: UIColor = .clear
    static var warning: UIColor = .clear
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let scanner = Scanner(string: hex.replacingOccurrences(of: "#", with: ""))
        var hexNumber: UInt32 = 0
        scanner.scanHexInt32(&hexNumber)
        let r = (hexNumber & 0xff0000) >> 16
        let g = (hexNumber & 0xff00) >> 8
        let b = hexNumber & 0xff
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff,
            alpha: alpha
        )
    }
}
