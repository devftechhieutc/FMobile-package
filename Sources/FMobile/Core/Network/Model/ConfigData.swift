//
//  File.swift
//
//
//  Created by Ishipo on 11/8/24.
//

import Foundation

struct BaseResponse: Codable {
    let status: Bool
    let code: Int
    let message: String
    let data: ConfigData
}

// MARK: - DataClass
public class ConfigData: NSObject, Codable {
    let name: String
    let bundleID: String
    let environment: FMobileEnvironment
    let platform: String
    let reviewMode: Bool
    let reviewVersion: String
    let supportOrientation: FMSupportOrientation
    let createdAt: String?
    let updatedAt: String?
    let publishedAt: String?
    let locale: String?
    let endpoints: Endpoints
    let themes: [ThemeConfig]
    let modules: [ModuleConfig]
    let thirdPartyConfigs: ThirdPartyConfigs
    
    enum CodingKeys: String, CodingKey {
        case name
        case bundleID = "bundleId"
        case environment, platform, reviewMode, reviewVersion, supportOrientation, createdAt, updatedAt, publishedAt, locale, endpoints, themes, modules, thirdPartyConfigs
    }
}

public enum FMSupportOrientation: String, Codable {
    case landscape
    case portrait
}

public enum FMobileEnvironment: String, Codable {
    case dev
    case prod
}

// MARK: - Endpoints
class Endpoints: NSObject, Codable {
    let main: String
}

// MARK: - Module
public class ModuleConfig: Codable {
    let name: SDKModule
    let moduleStatus: ModuleStatus?
    let configs: Configs
}

public enum SDKModule: String, Codable {
    case admob = "admob"
    case appleAuth = "apple-auth"
    case appsflyerTracking = "appsflyer-tracking"
    case firebaseTracking = "firebase-tracking"
    case forgotPassword = "forgot-password"
    case facebookAuth = "facebook-auth"
    case googleAuth = "google-auth"
    case maintenance = "maintenance"
    case loginBiometrics = "login-biometrics"
    case loginAccount = "login-account"
    case registerAccount = "register-account"
}

enum ModuleStatus: String, Codable {
    case enable = "enable"
    case disable = "disable"
    case promotion = "promotion"
    case hidden = "hidden"
}

// MARK: - Configs
class Configs: NSObject, Codable {
    let enableBannerAds: Bool?
    let enableInterstitialAds: Bool?
    let enableRewardedAds: Bool?
    let enableNativeAdvancedAds: Bool?
    let enableAppOpenAds: Bool?
    let message: String?
    let url: String?
    let enableFirebaseAuth: Bool?
    let configsPrefix, afKey: String?
    let appStoreID, whitelist: String?
    let sessionTimeout: String?
    let enableShowPassword: Bool?
    let validateAccountPhone: Bool?
    let validateAccountEmail: Bool?
    let validatePassword: Bool?
    let passwordMinLength: Int?
    let passwordHasNumber: Bool?
    let passwordHasUppercase: Bool?
    let passwordHasSpecialChar: Bool?
    let enableRememberAccount: Bool?
    let enableRememberPassword: Bool?
    var enableRefCode: Bool?
    let requireRePassword: Bool?
    var requireAcceptPolicy: Bool?

    let urlPolicy: String?
    
    enum CodingKeys: String, CodingKey {
        case enableBannerAds, enableInterstitialAds, enableRewardedAds, enableNativeAdvancedAds, enableAppOpenAds, message, url, enableFirebaseAuth
        case configsPrefix = "prefix"
        case afKey
        case appStoreID = "appStoreId"
        case whitelist, sessionTimeout, enableShowPassword, validateAccountPhone, validateAccountEmail, validatePassword, passwordMinLength, passwordHasNumber, passwordHasUppercase, passwordHasSpecialChar, enableRememberAccount, enableRememberPassword, enableRefCode, requireRePassword, requireAcceptPolicy, urlPolicy
    }
}

public enum SchemeMode: String, Codable {
    case light = "light"
    case dark = "dark"
}

// MARK: - Theme
public class ThemeConfig: NSObject, Codable {
    var scheme: SchemeMode
    var createdAt: String
    var updatedAt: String

    var publishedAt: String?
    var locale: String?
    var font: String
    var colors: ColorTheme
    var images: ImageTheme
}

// MARK: - Colors
public class ColorTheme: NSObject, Codable {
    let scheme: SchemeMode
    let hyperLink, colorPrimary, gradientStartPrimary, gradientEndPrimary: String
    let disable, textPrimary, textSecondary, textHint: String
    let backgroundPrimary, success, divider, error: String
    let warning: String
}

// MARK: - Images
public class ImageTheme: NSObject, Codable {
    var scheme: SchemeMode
    var createdAt, updatedAt: String
    var publishedAt, locale: String?
    var loginFacebook: ImageSet?
    var loginGoogle: ImageSet?
    var loginApple: ImageSet?
    var loginBiometrics: ImageSet?
    var logo: ImageSet?
    var loginFacebookLanscape: ImageSet?
    var loginGoogleLanscape: ImageSet?
    var loginAppleLanscape: ImageSet?
    var loginBiometricsLanscape: ImageSet?
    var logoLanscape: ImageSet?
}

// MARK: - LoginFacebook

public class ImageSet: NSObject, Codable {
    let normal, disable, promotion: String?
}

// MARK: - ThirdPartyConfigs
public class ThirdPartyConfigs: NSObject, Codable {
    let facebookAppID: String?
    let facebookClientID: String?
    let firebaseServerClientID: String?
    let firebaseProjectID: String?
    
    enum CodingKeys: String, CodingKey {
        case facebookAppID = "facebookAppId"
        case facebookClientID = "facebookClientId"
        case firebaseServerClientID = "firebaseServerClientId"
        case firebaseProjectID = "firebaseProjectId"
    }
}
