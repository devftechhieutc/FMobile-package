//
//  LoginViewController.swift
//  FTechSDK
//
//  Created by QuangAnh on 30/10/24.
//

import UIKit
import SDWebImage
import Combine

private class FMobileBundle{}
internal class LoginViewController: FViewController {
    @IBOutlet weak var imageLogo: UIImageView!
    
    @IBOutlet weak var imageLoginFacebook: UIImageView!
    
    @IBOutlet weak var imageLoginGoogle: UIImageView!
    
    @IBOutlet weak var imageLoginApple: UIImageView!
    
    @IBOutlet weak var imageLoginBiometrics: UIImageView!
    
    @IBOutlet weak var buttonLogin: UIButton!
    
    @IBOutlet weak var viewAccount: UIView!
    
    @IBOutlet weak var viewPassword: UIView!
    
    @IBOutlet weak var labelLogin: UILabel!
    
    @IBOutlet weak var imageCheckMark: UIImageView!
    
    @IBOutlet weak var labelRemmberLogin: UILabel!
    
    @IBOutlet weak var viewRememberLogin: UIView!
    
    @IBOutlet weak var labelLoginOrSocial: UILabel!
    
    @IBOutlet weak var labelRegisterAccount: UILabel!
    
    @IBOutlet weak var buttonRegister: UIButton!
    
    @IBOutlet weak var buttonForgetPassword: UIButton!
    
    @IBOutlet weak var tfAccount: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var imgShowPassword: UIImageView!
    
    private var isRemember: Bool = false
    
    private var isShowPassword: Bool = true
    
    
    
    init() {
        super.init(nibName: "LoginViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FMobile.instace().authManager.add(self)
        NotificationCenter.default.addObserver(self, selector: #selector(showThePasswordViewController), name: UIApplication.didBecomeActiveNotification, object: nil)
        tfPassword.isSecureTextEntry = true
        setupUI()
    }

    func setupUI() {
        print("LOAD VIEW LOGIN")
        isRemember = UserDefaults.standard.bool(forKey: "remember")
        imageCheckMark.tintColor = isRemember ? UIColor.hyperLink : UIColor.divider
        imageCheckMark.image = UIImage(systemName: isRemember ? "checkmark.square.fill" : "square")
        
        if isRemember {
            tfAccount.text = UserDefaults.standard.string(forKey: "account")
            tfPassword.text = UserDefaults.standard.string(forKey: "password")
        }
        
        labelLogin.textColor = UIColor.textPrimary
        
        labelLogin.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        
        
        labelRemmberLogin.textColor = UIColor.textPrimary
        
        labelLoginOrSocial.textColor = UIColor.textSecondary
        
        buttonLogin.setTitle("ĐĂNG NHẬP", for: .normal)
        
        
        
        buttonLogin.fCornerRadius = 4
        
        viewAccount.fCornerRadius = 4
        viewAccount.fBorderWidth = 1
        viewAccount.fBorderColor = UIColor.divider
        
        viewPassword.fCornerRadius = 4
        viewPassword.fBorderWidth = 1
        viewPassword.fBorderColor = UIColor.divider
        
        let enableShowPassword = FMobileConfig.getModuleConfig(.loginAccount)?.configs.enableShowPassword ?? false
        
        viewRememberLogin.isHidden = !enableShowPassword
        
        imageCheckMark.isUserInteractionEnabled = true
        imageCheckMark.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickViewImageRemember)))
        
        imageLoginFacebook.isUserInteractionEnabled = true
        imageLoginFacebook.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickViewLoginFacebook)))
        
        imageLoginGoogle.isUserInteractionEnabled = true
        imageLoginGoogle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickViewLoginGoogle)))
        
        imageLoginApple.isUserInteractionEnabled = true
        imageLoginApple.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickViewLoginApple)))
        
        imageLoginBiometrics.isUserInteractionEnabled = true
        imageLoginBiometrics.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickViewLoginBiometrics)))
        
        imgShowPassword.isUserInteractionEnabled = true
        imgShowPassword.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickViewLoginShowPassword)))
        
        let urlLogo = URL(string: FMobileConfig.getThemedImage()?.logo?.normal ?? "")
        imageLogo.sd_setImage(with: urlLogo)
        
        imageLoginFacebook.loadImage(module: FMobileConfig.getModuleConfig(.facebookAuth),
                                     imageSet: FMobileConfig.getThemedImage()?.loginFacebook)
        
        imageLoginGoogle.loadImage(module: FMobileConfig.getModuleConfig(.googleAuth),
                                   imageSet: FMobileConfig.getThemedImage()?.loginGoogle)
        
        imageLoginApple.loadImage(module: FMobileConfig.getModuleConfig(.appleAuth),
                                  imageSet: FMobileConfig.getThemedImage()?.loginApple)
        
        imageLoginBiometrics.loadImage(module: FMobileConfig.getModuleConfig(.loginBiometrics),
                                       imageSet: FMobileConfig.getThemedImage()?.loginBiometrics)
        
        labelRegisterAccount.textColor = UIColor.textPrimary
        
        checkStatusButtonForgotPassword()
        checkStatusButtonLogin()
        checkButtonRegister()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkMaintenance()
    }
    
    private func checkButtonRegister() {
        let configsLogin = FMobileConfig.getModuleConfig(.registerAccount)
        let moduleStatusLogin = configsLogin?.moduleStatus
        
        buttonRegister.isEnabled = moduleStatusLogin == .enable
        buttonRegister.setTitleColor(moduleStatusLogin == .enable ? UIColor.hyperLink : UIColor.disable, for: .normal)
        buttonRegister.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    private func checkStatusButtonLogin() {
        let configsLogin = FMobileConfig.getModuleConfig(.loginAccount)
        let moduleStatusLogin = configsLogin?.moduleStatus
        
        setStatusButton(isEnable: moduleStatusLogin == .enable)
    }
    
   private func checkStatusButtonForgotPassword() {
        let configs = FMobileConfig.getModuleConfig(.forgotPassword)
        let moduleStatus = configs?.moduleStatus 
        switch moduleStatus {
        case .hidden:
            buttonForgetPassword.isHidden = true
            buttonForgetPassword.isEnabled = true
        default:
            buttonForgetPassword.isHidden = moduleStatus == .disable
            buttonForgetPassword.isEnabled = moduleStatus == .disable
            let attributedString = NSAttributedString(
                string: "Quên mật khẩu",
                attributes:[
                    NSAttributedString.Key.font :UIFont.systemFont(ofSize: 16, weight: .medium),
                    NSAttributedString.Key.foregroundColor : moduleStatus == .disable ? UIColor.disable : UIColor.hyperLink,
                    NSAttributedString.Key.underlineStyle:1.0
                ])
            buttonForgetPassword.setAttributedTitle(attributedString, for: .normal)
        }
    }
    
    func validateAccount() {
        
        let account = tfAccount.text ?? ""
        let password = tfPassword.text ?? ""
        
        let infoAlert = FMobileValidate.validateAccountAndPassword(isLogin: true, account: account, password: password, reEnterPassword: "")
        
        if infoAlert.1 != .success {
            FMobileAlert.bannerAlertView(view: self.view, title: infoAlert.0, status: infoAlert.1)
            return
        }
        
        if account != "" && password != "" {
            FMobile.instace().authManager.rememberSignIn(with: account, password, isRemember: self.isRemember)
        }
        
        print("SUCCESS ACCOUNT AND PASSWORD")
        FMobile.instace().authManager.login(command: self)
    }
    
    func setStatusButton(isEnable: Bool) {
        buttonLogin.isEnabled = isEnable
        buttonLogin.setTitleColor(isEnable ? UIColor.backgroundPrimary : UIColor.textSecondary, for: .normal)
        buttonLogin.backgroundColor = isEnable ? UIColor.gradientEndPrimary : UIColor.disable
    }
    
    func checkMaintenance() {
        let configsLogin = FMobileConfig.getModuleConfig(.maintenance)
        let moduleStatusLogin = configsLogin?.moduleStatus
        let mess = configsLogin?.configs.message ?? ""
        if moduleStatusLogin == .enable {
            let title = NSAttributedString(string: "Thông báo!")
            let message = NSAttributedString(string: mess)
            let vc = AlertViewController(title: title, message: message, preferredStyle: .alert)
            
            let buttonDetail = TIOAlertAction(title: "Chi tiết", style: .default)
            vc.addActions([buttonDetail])
            
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        }
        
   
    }
    
    @objc func showThePasswordViewController() {
        setupUI()
        }
    
    @objc
    private func onClickViewImageRemember(_ sender: UITapGestureRecognizer?){
        isRemember.toggle()
        imageCheckMark.tintColor = isRemember ? UIColor.hyperLink : UIColor.divider
        imageCheckMark.image = UIImage(systemName: isRemember ? "checkmark.square.fill" : "square")
       
    }
    
    @objc
    private func onClickViewLoginFacebook(_ sender: UITapGestureRecognizer?){
        print("LOGIN FACEBOOK")
        FMobile.instace().authManager.loginFacebook(with: self)
    }
    
    @objc
    private func onClickViewLoginGoogle(_ sender: UITapGestureRecognizer?){
        print("LOGIN GOOGLE")
        FMobile.instace().authManager.loginGoogle(with: self)
    }
    
    @objc
    private func onClickViewLoginApple(_ sender: UITapGestureRecognizer?){
        print("LOGIN APPLE")
        FMobile.instace().authManager.loginApple(with: self)
    }
    
    @objc
    private func onClickViewLoginBiometrics(_ sender: UITapGestureRecognizer?){
        print("LOGIN BIOMETRICS")
        FMobile.instace().authManager.loginWithBiometric(with: self)
    }
    
    @objc
    private func onClickViewLoginShowPassword(_ sender: UITapGestureRecognizer?){
      
        isShowPassword.toggle()
        imgShowPassword.image = UIImage(systemName: isShowPassword ? "eye.slash.fill" :"eye.fill")
        tfPassword.isSecureTextEntry = isShowPassword
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        validateAccount()
    }
    
        
        
    @IBAction func actionRegister(_ sender: Any) {
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginViewController: FMobileLoginCommand {
    func execute(with account: String, password: String) -> AnyPublisher<String, NSError> {
        return Future<String, NSError> { promise in
            // handle login with module
            promise(.success(""))
        }
        .eraseToAnyPublisher()
    }
}

extension LoginViewController: AuthManagerDelegate {
    func didSignInSuccess(with token: String) {
        print("didSignInSuccess \(token)")
    }
    
    func didSignInFailure(_ error: FMobileError) {
        print("didSignInFailure \(error)")
    }
    
    func didSignOut() {
        print("didSignOut")
    }
    
    
}


