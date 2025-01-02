//
//  FBUGoogleAuthenProvider.swift
//  FirebaseAuthUnity
//
//  Created by Ishipo on 6/4/24.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

class GoogleAuthenProvider: FM3rdAuthenProvider {
    
    override func authorize(_ context: UIViewController?, _ delegate: MulticastDelegate<any AuthManagerDelegate>) {
        super.authorize(context, delegate)
        guard let context = context else { return }
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                
        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.configuration = config


        GIDSignIn.sharedInstance.signIn(withPresenting: context) { authentication, error in
            if let code = (error as? NSError)?.code, code == GIDSignInError.canceled.rawValue {
                return
            }
            if let error = error {
                delegate.invoke {
                    $0.didSignInFailure(FMobileError(with: error))
                }
                return
            }
            
            guard
                let user = authentication?.user,
                let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
             let isEnableFA = FMobileConfig.getModuleConfig(.googleAuth)?.configs.enableFirebaseAuth ?? false

            if isEnableFA {
                self.signInWithAppAuth(credential, idToken: idToken)
            } else {
                let result = FM3rdResult(idToken: idToken, authToken: user.accessToken.tokenString)                
                delegate.invoke {
                    $0.didSignInSuccess(with: result.authToken)
                }
            }
        }
    }
    
   
    override func signOut() {
        GIDSignIn.sharedInstance.signOut()
        super.signOut()
    }
}
