//
//  ImageScheme.swift
//  FTechSDK
//
//  Created by QuangAnh on 30/10/24.
//
import UIKit

public protocol ThemedImage: AnyObject {
    var loginFacebook: ImageSet? {get set}
    var loginGoogle: ImageSet? {get set}
    var loginApple: ImageSet? {get set}
    var loginBiometrics: ImageSet? {get set}
    var logo: ImageSet? {get set}
    var loginFacebookLanscape: ImageSet? {get set}
    var loginGoogleLanscape: ImageSet? {get set}
    var loginAppleLanscape: ImageSet? {get set}
    var loginBiometricsLanscape: ImageSet? {get set}
    var logoLanscape: ImageSet? {get set}
}


public class FMobileThemedImage: NSObject, ThemedImage {
    
    public var loginFacebook: ImageSet?
    
    public var loginGoogle: ImageSet?
    
    public var loginApple: ImageSet?
    
    public var loginBiometrics: ImageSet?
    
    public var logo: ImageSet?
    
    public var loginFacebookLanscape: ImageSet?
    
    public var loginGoogleLanscape: ImageSet?
    
    public var loginAppleLanscape: ImageSet?
    
    public var loginBiometricsLanscape: ImageSet?
    
    public var logoLanscape: ImageSet?
    
}
