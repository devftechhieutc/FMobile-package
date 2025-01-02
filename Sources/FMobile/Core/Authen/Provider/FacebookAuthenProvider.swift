//
//  FBUFacebookAuthenProvider.swift
//  FirebaseAuthUnity
//
//  Created by Ishipo on 6/4/24.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth

class FacebookAuthenProvider: FM3rdAuthenProvider {
    
    private var fbLoginManager: LoginManager?
    
    override func authorize(_ context: UIViewController?, _ delegate: MulticastDelegate<any AuthManagerDelegate>) {
        super.authorize(context, delegate)
        if fbLoginManager == nil {
            fbLoginManager = LoginManager()
        }
        fbLoginManager?.logOut()
        //                let config = LoginConfiguration(permissions: ["public_profile", "email"])
        fbLoginManager?.logIn(permissions: ["public_profile", "email"],
                              from: context, handler: { result, error in
            self.handleFacebookLoginResult(result, error: error)
        })
    }
    
    private func handleFacebookLoginResult(_ loginResult: LoginManagerLoginResult?, error: Error?) {
        if loginResult?.isCancelled ?? false {
            return
        }
        guard let loginResult = loginResult, let tokenString = loginResult.token?.tokenString, error == nil else {
            delegate?.invoke {
                $0.didSignInFailure(FMobileError(with: error ?? NSError()))
            }
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
        
        let isEnableFA = FMobileConfig.getModuleConfig(.facebookAuth)?.configs.enableFirebaseAuth ?? false
        
        if isEnableFA {
            self.signInWithAppAuth(credential, idToken: tokenString)
        } else {
            _ = FM3rdResult(idToken: "", authToken: tokenString)
            delegate?.invoke {
                $0.didSignInSuccess(with: tokenString)
            }
        }
    }
}
