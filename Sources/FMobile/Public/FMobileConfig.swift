//
//  File.swift
//
//
//  Created by Ishipo on 11/8/24.
//

import Foundation
import UIKit

final public class FMobileConfig: NSObject {
    public static var name: String?
    public static var bundleID: String?
    public static var environment: FMobileEnvironment = .dev
    public static var platform: String?
    public static var reviewMode: Bool = false
    public static var reviewVersion: String?
    public static var supportOrientation: FMSupportOrientation = .portrait
    public static var endpoints: String?
    public static var themes: [ThemeConfig]?
    public static var modules: [ModuleConfig]?
    public static var thirdPartyConfigs: ThirdPartyConfigs?
    internal static var licenseKey: String = ""
    
    public static var scheme: SchemeMode = .light {
        
        didSet {
            loadThemeColor()
        }
    }
    
    public static func setEnviroment(_ env: FMobileEnvironment) {
        self.environment = env
    }
    
    public static func setSDKLicense(_ key: String) {
        self.licenseKey = key
    }
    
    public static func getModuleConfig(_ module: SDKModule) -> ModuleConfig? {
        return modules?.first(where: {$0.name == module})
    }
    
    
    public static func getThemedImage() -> ImageTheme? {
        return themes?.first(where: {$0.scheme == scheme})?.images
    }
    
    internal static func loadThemeColor() {
        guard let themed = themes?.first(where: {$0.scheme == scheme}) else {
            return
        }
        let colors = themed.colors
        let themedColor = FMobileThemedColor()
        themedColor.primary = colors.colorPrimary
        themedColor.hyperLink = colors.hyperLink
        themedColor.gradientStartPrimary = colors.gradientStartPrimary
        themedColor.gradientEndPrimary = colors.gradientEndPrimary
        themedColor.disable = colors.disable
        themedColor.textPrimary = colors.textPrimary
        themedColor.textSecondary = colors.textSecondary
        themedColor.textHint = colors.textHint
        themedColor.backgroundPrimary = colors.backgroundPrimary
        themedColor.success = colors.success
        themedColor.divider = colors.divider
        themedColor.error = colors.error
        invoke(theme: themedColor)
    }
    
    public static func invoke(theme: ThemedColor) {
        UIColor.primary = UIColor(hex: theme.primary)
        UIColor.hyperLink = UIColor(hex: theme.hyperLink)
        UIColor.gradientStartPrimary = UIColor(hex: theme.gradientStartPrimary)
        UIColor.gradientEndPrimary = UIColor(hex: theme.gradientEndPrimary)
        UIColor.disable = UIColor(hex: theme.disable)
        UIColor.textPrimary = UIColor(hex: theme.textPrimary)
        UIColor.textSecondary = UIColor(hex: theme.textSecondary)
        UIColor.textHint = UIColor(hex: theme.textHint)
        UIColor.backgroundPrimary = UIColor(hex: theme.backgroundPrimary)
        UIColor.success = UIColor(hex: theme.success)
        UIColor.divider = UIColor(hex: theme.divider)
        UIColor.error = UIColor(hex: theme.error)
        UIColor.warning = .systemYellow
    }
    
    public static func invoke(theme: ThemedImage) {
        guard let themed = themes?.first(where: {$0.scheme == scheme}) else {
            return
        }
        copyMatchingProperties(from: theme, to: &themed.images)
    }
    
   internal static func copyMatchingProperties(from source: ThemedImage, to target: inout ImageTheme) {
        let sourceMirror = Mirror(reflecting: source)
        let targetMirror = Mirror(reflecting: target)

 
        for child in sourceMirror.children {
            if let propertyName = child.label {
                // Tìm thuộc tính trong target có cùng tên với source
                if targetMirror.children.contains(where: { $0.label == propertyName }) {
                    if let _ = (source as! NSObject).value(forKey: propertyName) {
                        // Sử dụng KVC để gán giá trị nếu tên thuộc tính khớp
                        target.setValue(child.value, forKey: propertyName)
                    }
             
                }
            }
        }
    }
}
