//
//  AuthManager.swift
//  FTechSDK
//
//  Created by QuangAnh on 30/10/24.
//
import UIKit
import Combine

public protocol FMobileLoginCommand {
    func execute(with account: String, password: String) -> AnyPublisher<String, NSError>
}

public protocol AuthManagerDelegate: AnyObject {
    func didSignInSuccess(with token: String)
    func didSignInFailure(_ error: FMobileError)
    func didSignOut()
}

@objcMembers
final public class AuthManager {
    private var delegate = MulticastDelegate<AuthManagerDelegate>()
    
    private static var shared = AuthManager()
    
    public static func instace() -> AuthManager {
        return shared
    }
    private let userdefault = UserDefaults.standard
    private var cancellable = Set<AnyCancellable>()
    
    
    /// Login with user name and password
    /// - Parameters:\
    ///   - userName: username: String
    ///   - password: password: String
    public func login(command: FMobileLoginCommand) {
        command.execute(with: "", password: "")
            .replaceError(with: "")
            .sink(receiveValue: { [weak self] data in
                self?.delegate.invoke {
                    $0.didSignInSuccess(with: data)
                }
            })
            .store(in: &cancellable)
            
        
        moduleLog("call login username")
    }
    
    /// Login With Apple
    /// - Parameter viewController: ViewController is present form login
    public func loginApple(with context: UIViewController) {
        AuthProviderFactory.getAppleProvider().authorize(context, delegate)
//        invoke(provider: FMAppleAuthenProvider.self, type: .apple)
//        let option = FMobile.instace().option
//        moduleLog(option)
    }
    
    /// Login with Facebook
    /// - Parameter viewController: ViewController is present form login
    public func loginFacebook(with context: UIViewController) {
        AuthProviderFactory.getFacebookProvider().authorize(context, delegate)
        moduleLog("call login facebook")
    }
    
    /// Login with Google
    /// - Parameter viewController: ViewController is present form login
    public func loginGoogle(with context: UIViewController) {
        AuthProviderFactory.getGoogleProvider().authorize(context, delegate)
        moduleLog("call login google")
    }
    
    public func loginZalo() {
        AuthProviderFactory.getZaloProvider().authorize(nil, delegate)

        
    }
    /// Login with Telegram
    /// - Parameter viewController: ViewController is present form login
    public func loginTelegram(with context: UIViewController) {
        AuthProviderFactory.getAppleProvider().authorize(context, delegate)
        moduleLog("call login telegram")
    }
    
    /// Use form login SDK
    public func loginWithSDKForm(context: UIViewController){
        let vc = LoginViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isHidden = true
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .crossDissolve
        context.present(nav, animated: true)
    }
    
    public func loginWithBiometric(with context: UIViewController) {
        AuthProviderFactory.getBiometricProvider().authorize(context, delegate)
        moduleLog("call login biometric")

    }
    
    /// Logout
    public func logout(){
        delegate.invoke {
            $0.didSignOut()
        }
        moduleLog("call logout")
    }
    
    
    public func forgotPassword() {
        
    }
    
    /// Regiser new user
    /// - Parameters:
    ///   - userName: email
    ///   - password: password
    ///   - referencesCode: code user ref
    public func register(with userName: String, _ password: String, _ referencesCode: String) {
        
    }
    
    func rememberSignIn(with account: String, _ password: String, isRemember: Bool) {
        userdefault.set(isRemember, forKey: "remember")
        if isRemember {
            userdefault.set(account, forKey: "account")
            userdefault.set(password, forKey: "password")
        } else {
            userdefault.removeObject(forKey: "account")
            userdefault.removeObject(forKey: "password")
        }
       
    }
    
    /// show/hidden pass word
    /// - Parameter isVisible: default = false
    func visiblePassword(isVisible: Bool) {
        
    }
    
    func validatePassword() {
        
    }
    
    
    public func add(_ delegate: AuthManagerDelegate) {
        self.delegate.add(delegate)
    }
}

