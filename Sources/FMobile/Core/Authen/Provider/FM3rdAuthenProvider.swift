//
//  FBU3rdAuthProvider.swift
//  FirebaseAuthUnity
//
//  Created by Ishipo on 6/4/24.
//

import Foundation
import UIKit
import CryptoKit
import CommonCrypto
import FirebaseAuth


protocol FM3rdAuthProviderProtocol: NSObjectProtocol {
    init()
    func authorize(_ context: UIViewController?, _ delegate: MulticastDelegate<AuthManagerDelegate>)
    func signOut()
}

public protocol FM3rdAuthProtocol: AnyObject {
    var idToken: String { get }
    var authToken: String { get }
}



internal class FM3rdResult: FM3rdAuthProtocol {
    var idToken: String {
        return _idToken
    }
    
    var authToken: String {
        return _authToken
    }
    
    private let _idToken: String
    private let _authToken: String
    
    init(idToken: String, authToken: String) {
        self._idToken = idToken
        self._authToken = authToken
    }
}


class FM3rdAuthenProvider: NSObject, FM3rdAuthProviderProtocol {
    
    required override init() {
        super.init()
    }
    
    internal var currentNonce: String?
    
    internal var delegate: MulticastDelegate<AuthManagerDelegate>? = nil
    
    internal var completed: ((Result<FM3rdAuthProtocol, FMobileError>) -> Void)?

    
    func authorize(_ context: UIViewController?, _ delegate: MulticastDelegate<AuthManagerDelegate>) {
        self.delegate = delegate
    }
    
    func signOut() {
        try? Auth.auth().signOut()
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    internal func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    internal func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        if #available(iOS 13.0, *) {
            let hashedData = SHA256.hash(data: inputData)
            let hashString = hashedData.compactMap {
                String(format: "%02x", $0)
            }.joined()
            return hashString
        }
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        inputData.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(inputData.count), &hash)
        }
        let hashString = hash.compactMap {
            String(format: "%02x", $0)
        }.joined()
        return hashString
    }
    
    
    internal func signInWithAppAuth(_ cer: AuthCredential, idToken: String) {
        // Sign in with Firebase.
        Auth.auth().signIn(with: cer) { authResult, e in
            if let error = e {
                self.delegate?.invoke {
                    $0.didSignInFailure(FMobileError(with: error))
                }
                return
            }
            authResult?.user.getIDTokenForcingRefresh(false, completion: { firebaseToken, err in
                if let authToken = firebaseToken {
                    let result = FM3rdResult(idToken: idToken, authToken: authToken)
                    self.delegate?.invoke {
                        $0.didSignInSuccess(with: authToken)
                    }
                }
            })
        }
    }
}
