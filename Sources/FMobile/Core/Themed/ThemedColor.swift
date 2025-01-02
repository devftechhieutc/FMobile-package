//
//  ColorScheme.swift
//  FTechSDK
//
//  Created by QuangAnh on 30/10/24.
//

import UIKit

@objc public protocol ThemedColor {
    var primary: String {get set}
    var hyperLink: String {get set}
    var gradientStartPrimary: String {get set}
    var gradientEndPrimary:String {get set}
    var disable: String {get set}
    var textPrimary: String {get set}
    var textSecondary: String {get set}
    var textHint: String {get set}
    var backgroundPrimary: String {get set}
    var success: String {get set}
    var divider: String {get set}
    var error: String {get set}
    var errwarningor: String {get set}
}


public class FMobileThemedColor: ThemedColor {
    public var primary: String = ""
    
    public var hyperLink: String = ""
    
    public var gradientStartPrimary: String = ""
    
    public var gradientEndPrimary: String = ""
    
    public var disable: String = ""
    
    public var textPrimary: String = ""
    
    public var textSecondary: String = ""
    
    public var textHint: String = ""
    
    public var backgroundPrimary: String = ""
    
    public var success: String = ""
    
    public var divider: String = ""
    
    public var error: String = ""
    
    public var errwarningor: String = ""
    
}
