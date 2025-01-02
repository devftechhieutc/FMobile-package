//
//  File.swift
//
//
//  Created by Ishipo on 11/8/24.
//

import UIKit
import LocalAuthentication

class BiometricAuthenProvider: FM3rdAuthenProvider {
    
    override func authorize(_ context: UIViewController?, _ delegate: MulticastDelegate<any AuthManagerDelegate>) {
        
        let context = LAContext()
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate using Face ID or Touch ID") { success, error in
            delegate.invoke {
                $0.didSignInSuccess(with: "FaceID")
            }
        }
        
    }
    
    
    func canUseBiometricAuthentication() -> Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    func getBiometricType() -> LABiometryType {
        let context = LAContext()
        return context.biometryType
    }
}
