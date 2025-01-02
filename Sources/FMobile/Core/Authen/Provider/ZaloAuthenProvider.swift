//
//  File.swift
//
//
//  Created by Ishipo on 11/5/24.
//

import Foundation

#if os(Linux)
import Crypto
#else
import CommonCrypto
#endif

import ZaloSDK

class ZaloAuthenProvider: FM3rdAuthenProvider {
    
    override func authorize(_ context: UIViewController?, _ delegate: MulticastDelegate<any AuthManagerDelegate>) {
        super.authorize(context, delegate)
        
        let codeVerifier = generateCodeVerifier() ?? ""
        let codeChallenage = generateCodeChallenge(codeVerifier: codeVerifier) ?? ""
        
        ZaloSDK.sharedInstance().authenticateZalo(with: ZAZAloSDKAuthenTypeViaZaloAppAndWebView,
                                                  parentController: context,
                                                  codeChallenge: codeChallenage,
                                                  extInfo: FMobileConstants.EXT_INFO) { response in
            if response?.isSucess == true {
                // Đăng nhập thành công, thực hiện get AccessToken bằng response?.oauthCode
                self.getAccessTokenFromOAuthCode(response?.oauthCode, codeVerifier: codeVerifier)
            }
        }
    }
    
    override func signOut() {
        ZaloSDK.sharedInstance().unauthenticate()
    }
    
    internal func getAccessTokenFromOAuthCode(_ oauthCode: String?, codeVerifier: String) {
        ZaloSDK.sharedInstance().getAccessToken(withOAuthCode: oauthCode, codeVerifier: codeVerifier) {[weak self] tokenResponse in
            if let tokenResponse = tokenResponse {
                print("""
                      getAccessTokenFromOAuthCode:
                      accessToken: \(tokenResponse.accessToken ?? "")
                      refreshToken: \(tokenResponse.refreshToken ?? "")
                      expriedTime: \(tokenResponse.expriedTime)
                      """)
            } else {
                print("""
                      Get AccessToken from OauthCode error \(tokenResponse?.errorCode ?? ZaloSDKErrorCode.sdkErrorCodeUnknownException.rawValue)
                      Message: \(tokenResponse?.errorMessage ?? "")
                      """)
                
                self?.delegate?.invoke {
                    let e = FMobileError(code: tokenResponse?.errorCode ?? ZaloSDKErrorCode.sdkErrorCodeUnknownException.rawValue,
                                         message: tokenResponse?.errorMessage ?? "")
                    $0.didSignInFailure(e)
                }
            }
        }
    }
    internal func generateState(withLength len: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let length = UInt32(letters.count)
        
        var randomString = ""
        for _ in 0..<len {
            let rand = arc4random_uniform(length)
            let idx = letters.index(letters.startIndex, offsetBy: Int(rand))
            let letter = letters[idx]
            randomString += String(letter)
        }
        return randomString
    }
    
    /// Generating a code verifier for PKCE
    internal func generateCodeVerifier() -> String? {
        var buffer = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
        let codeVerifier = Data(buffer).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        return codeVerifier
    }
    
    /// Generating a code challenge for PKCE
    internal func generateCodeChallenge(codeVerifier: String?) -> String? {
        guard let verifier = codeVerifier, let data = verifier.data(using: .utf8) else { return nil }
        
#if !os(Linux)
        var buffer = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &buffer)
        }
        let hash = Data(buffer)
#else
        let buffer = [UInt8](repeating: 0, count: SHA256.byteCount)
        let sha = Array(HMAC<SHA256>.authenticationCode(for: buffer, using: SymmetricKey(size: .bits256)))
        let hash = Data(sha)
#endif
        
        let challenge = hash.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        return challenge
    }
}


