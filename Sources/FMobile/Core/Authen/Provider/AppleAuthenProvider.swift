//
//  FBUAppleAuthenProvider.swift
//  FirebaseAuthUnity
//
//  Created by Ishipo on 6/4/24.
//

import Foundation
import UIKit
import AuthenticationServices
import FirebaseAuth


class AppleAuthenProvider: FM3rdAuthenProvider {
    
    override func authorize(_ context: UIViewController?, _ delegate: MulticastDelegate<AuthManagerDelegate>) {
        self.delegate = nil
        if #available(iOS 13, *) {
            super.authorize(context, delegate)
            let nonce = randomNonceString()
            currentNonce = nonce
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = context
            authorizationController.presentationContextProvider = context as? ASAuthorizationControllerPresentationContextProviding
            authorizationController.performRequests()
            
            context?.signInWithAppleSuccess = {
                self.processing(with: $0)
            }
            
            context?.signInWithAppleFailure = {
                self.handling(with: $0)
            }
        }
    }
}

//@available(iOS 13.0, *)
extension AppleAuthenProvider {
    
    internal func processing(with authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let appleIDToken = appleIDCredential.identityToken else {
                delegate?.invoke {
                    $0.didSignInFailure(FMobileError(code: 2, message: "Unable to fetch identity token"))
                }
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                delegate?.invoke {
                    $0.didSignInFailure(FMobileError(code: 3, message: "Unable to serialize token string from data: \(appleIDToken.debugDescription)"))
                }
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: currentNonce ?? "")
            
            
            let isEnableFA = FMobileConfig.getModuleConfig(.appleAuth)?.configs.enableFirebaseAuth ?? false
            
            if isEnableFA {
                self.signInWithAppAuth(credential, idToken: idTokenString)
            } else {
                _ = FM3rdResult(idToken: "", authToken: idTokenString)
                
                delegate?.invoke {
                    $0.didSignInSuccess(with: idTokenString)
                }
            }
        }
    }
    
    internal func handling(with error: Error) {
        delegate?.invoke{
            $0.didSignInFailure(FMobileError(with: error))
        }
    }
}

extension UIViewController: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        signInWithAppleSuccess?(authorization)
      
    }
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        signInWithAppleFailure?(error)
    }
}

private struct AppleKeys {
    static var signInWithAppleSucess = malloc(1)
    static var signInWithAppleFailure = malloc(1)
}
extension UIViewController {
    internal var signInWithAppleSuccess: ((_ authorization: ASAuthorization ) -> Void)? {
        get {objc_getAssociatedObject(self, &AppleKeys.signInWithAppleSucess) as? ((ASAuthorization) -> Void) }
        set {objc_setAssociatedObject(self, &AppleKeys.signInWithAppleSucess, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }   
    internal var signInWithAppleFailure: ((_ error: Error ) -> Void)? {
        get {objc_getAssociatedObject(self, &AppleKeys.signInWithAppleFailure) as? ((Error) -> Void) }
        set {objc_setAssociatedObject(self, &AppleKeys.signInWithAppleFailure, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
}
