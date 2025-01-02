//
//  FBASDK.swift
//
//
//  Created by Ishipo on 6/6/24.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn
import ZaloSDK
import ZaloSDKCoreKit
import FirebaseCore
import Combine

public class FMobileAppdelegate: NSObject {
    
   internal static var  cancellable = Set<AnyCancellable>()
    
    @objc public static func didFinishLaunching(_ application: UIApplication, with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        ZaloSDK.sharedInstance().initialize(withAppId: FMobileConstants.ZALO_APP_ID)
        FirebaseApp.configure()
        
        guard !FMobileConfig.licenseKey.isEmpty else {
            print("License not found")
            return
        }
        
        // get config
        NetworkManager.shared.getSuperConfig()
            .sink {  completion in
                switch completion {
                case .finished:
                    print("Request completed successfully")
                case .failure(let error):
                    print("Failed with error: \(error.localizedDescription)")
                }
            } receiveValue: {
                attrachConfig(data: $0)
            }
            .store(in: &cancellable)
    }
    
    @discardableResult
    @objc public static func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]?) -> Bool {
     
        let source = options?[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
        let annotation = options?[UIApplication.OpenURLOptionsKey.annotation]
        
        //FaceBook
        let handleFB = ApplicationDelegate.shared.application(app,open: url, sourceApplication: source, annotation: annotation)
        if handleFB {
            return handleFB
        }
        //Google
        let handleGG = GIDSignIn.sharedInstance.handle(url)
        if handleGG {
            return handleGG
        }
        //Zalo
        let handleZalo = ZDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        if handleZalo {
            return handleZalo
        }
        
        return false
    }
    
    @discardableResult
    @objc public static func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
     
        let handleFB = ApplicationDelegate.shared.application(application,open: url,
                                                              sourceApplication: sourceApplication,
                                                              annotation: annotation)
        if handleFB {
            return handleFB
        }
        let handleGG = GIDSignIn.sharedInstance.handle(url)
        if handleGG {
            return handleGG
        }
        
        return false
    }
    
    
    public static func attrachConfigDarkMode() {
        let mode = UIScreen.main.traitCollection.userInterfaceStyle.rawValue
        switch mode {
        case 1:
            FMobileConfig.scheme = .light
        case 2:
            FMobileConfig.scheme = .dark
        default:
            
            FMobileConfig.scheme = .dark
            
        }
    }
    internal static func attrachConfig(data: ConfigData) {
        FMobileConfig.name = data.name
        FMobileConfig.bundleID = data.bundleID
        FMobileConfig.environment = data.environment
        FMobileConfig.platform = data.platform
        FMobileConfig.reviewMode = data.reviewMode
        FMobileConfig.reviewVersion = data.reviewVersion
        FMobileConfig.supportOrientation = data.supportOrientation
        FMobileConfig.endpoints = data.endpoints.main
        FMobileConfig.themes = data.themes
        FMobileConfig.modules = data.modules
        FMobileConfig.thirdPartyConfigs = data.thirdPartyConfigs
        FMobileConfig.loadThemeColor()
        
        if let appID = data.thirdPartyConfigs.facebookAppID, let clientID = data.thirdPartyConfigs.facebookClientID {
            Settings.shared.appID = appID
            Settings.shared.clientToken = clientID
            Settings.shared.displayName = "FMobile"
        }
    }
}
