//
//  File.swift
//  
//
//  Created by Ishipo on 11/8/24.
//

import Foundation

struct AuthProviderFactory {
    static func getAppleProvider() -> FM3rdAuthProviderProtocol {
        return AppleAuthenProvider()
    }
    
    static func getGoogleProvider() -> FM3rdAuthProviderProtocol {
        return GoogleAuthenProvider()
    }
    
    static func getZaloProvider() -> FM3rdAuthProviderProtocol {
        return ZaloAuthenProvider()
    }
    
    static func getFacebookProvider() -> FM3rdAuthProviderProtocol {
        return FacebookAuthenProvider()
    }
    
    static func getBiometricProvider() -> FM3rdAuthProviderProtocol {
        return BiometricAuthenProvider()
    }
}
