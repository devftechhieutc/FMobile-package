//
//  RegisterViewController.swift
//  FMobile
//
//  Created by Tran Hieu on 13/11/24.
//

import UIKit

class RegisterViewController: FViewController {
    
    @IBOutlet weak var imageBack: UIImageView!
    
    @IBOutlet weak var labelRegister: UILabel!
    
    
    @IBOutlet weak var viewInputAccount: UIView!
    
    @IBOutlet weak var iconAccount: UIImageView!
    
    @IBOutlet weak var tfAccount: UITextField!
    
    
    @IBOutlet weak var viewInputPassword: UIView!
    
    @IBOutlet weak var iconPassword: UIImageView!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var iconShowPassword: UIImageView!
    
    
    @IBOutlet weak var viewInputReEnterPassword: UIView!
    
    @IBOutlet weak var iconReEnterPassword: UIImageView!
    
    @IBOutlet weak var tfReEnterPassword: UITextField!
    
    @IBOutlet weak var iconShowReEnterPassword: UIImageView!
    
    
    @IBOutlet weak var viewInputReferral: UIView!
    
    @IBOutlet weak var iconReferral: UIImageView!
    
    @IBOutlet weak var tfReferral: UITextField!
    
    
    @IBOutlet weak var viewTermsOfUse: UIView!
    
    @IBOutlet weak var imageTermsOfUse: UIImageView!
    
    @IBOutlet weak var labelTermsOfUse: UILabel!
    
    
    @IBOutlet weak var buttonRegister: UIButton!
    
    @IBOutlet weak var imgShowPassword: UIImageView!
    
    @IBOutlet weak var imgShowReEnterPassword: UIImageView!
    
    private var isPolicy: Bool = false
    
    private var isShowPassword: Bool = true
    
    private var isShowReEnterPassword: Bool = true
    
    private let configsRegister = FMobileConfig.getModuleConfig(.registerAccount)?.configs
    
    init() {
        super.init(nibName: "RegisterViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showThePasswordViewController), name: UIApplication.didBecomeActiveNotification, object: nil)
        tfReEnterPassword.isSecureTextEntry = true
        tfPassword.isSecureTextEntry = true
        imageTermsOfUse.image = UIImage(systemName: "square")
        imageTermsOfUse.tintColor = UIColor.divider
        setupView()
    }
    
    func setupView() {
        
        imageBack.image = UIImage(systemName: "arrow.left")
        imageBack.tintColor = UIColor.textHint
        
        labelRegister.textColor = UIColor.textPrimary
        
        buttonRegister.setTitle("ĐĂNG KÝ", for: .normal)
        
        buttonRegister.setTitleColor(UIColor.backgroundPrimary, for: .normal)
        
        buttonRegister.fCornerRadius = 4
        
        viewInputAccount.fCornerRadius = 4
        viewInputAccount.fBorderWidth = 1
        viewInputAccount.fBorderColor = UIColor.divider
        
        viewInputPassword.fCornerRadius = 4
        viewInputPassword.fBorderWidth = 1
        viewInputPassword.fBorderColor = UIColor.divider
        
        viewInputReEnterPassword.fCornerRadius = 4
        viewInputReEnterPassword.fBorderWidth = 1
        viewInputReEnterPassword.fBorderColor = UIColor.divider
        
        viewInputReferral.fCornerRadius = 4
        viewInputReferral.fBorderWidth = 1
        viewInputReferral.fBorderColor = UIColor.divider
        
        imageTermsOfUse.isUserInteractionEnabled = true
        imageTermsOfUse.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickViewImageRemember)))
        
        imgShowPassword.isUserInteractionEnabled = true
        imgShowPassword.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickViewLoginShowPassword)))
        
        
        imgShowReEnterPassword.isUserInteractionEnabled = true
        imgShowReEnterPassword.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickViewLoginShowReEnterPassword)))
        
        imageBack.isUserInteractionEnabled = true
        imageBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickViewBack)))
        
        labelTermsOfUse.isUserInteractionEnabled = true
        labelTermsOfUse.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickTermsOfUse)))
        
        labelTermsOfUse.attributedText =  AttributedStringBuilder()
            .append("Bằng việc tích vào ô bên cạnh, bạn đã đồng ý với ")
            .with(UIFont.systemFont(ofSize: 14))
            .with(UIColor.textPrimary)
        
            .append(" điều khoản")
            .with(UIFont.systemFont(ofSize: 14, weight: .semibold))
            .with(UIColor.hyperLink)
        
            .append(" và ")
            .with(UIFont.systemFont(ofSize: 14))
            .with(UIColor.textPrimary)
        
            .append("chính sách ")
            .with(UIFont.systemFont(ofSize: 14, weight: .semibold))
            .with(UIColor.hyperLink)
        
            .append("của chúng tôi")
            .with(UIFont.systemFont(ofSize: 14))
            .with(UIColor.textPrimary)
        
            .attributedString()
        
        setupViewReferal()
        setupShowPassword()
        setupRequireRePassword()
        setupRequireAcceptPolicy()
    }
    func setupViewReferal() {
        
        let enableRefCode = configsRegister?.enableRefCode ?? false
        viewInputReferral.isHidden = !enableRefCode
    }
    
    func setupShowPassword() {
        let enableShowPassword = configsRegister?.enableShowPassword ?? false
        imgShowPassword.isHidden = !enableShowPassword
        imgShowReEnterPassword.isHidden = !enableShowPassword
    }
    
    func setupRequireRePassword() {
        let requireRePassword = configsRegister?.requireRePassword ?? true
        viewInputReEnterPassword.isHidden = !requireRePassword
    }
    
    func setupRequireAcceptPolicy() {
        let requireAcceptPolicy = configsRegister?.requireAcceptPolicy ?? true
        viewTermsOfUse.isHidden = !requireAcceptPolicy
    }
    
    func validateRegister() {
        let account = tfAccount.text ?? ""
        let password = tfPassword.text ?? ""
        let reEnterPassword = tfReEnterPassword.text ?? ""
        let referalCode = tfReferral.text ?? ""
        let configs = FMobileConfig.getModuleConfig(.registerAccount)?.configs
        let requireAcceptPolicy = configs?.requireAcceptPolicy ?? true
        
        let infoAlert = FMobileValidate.validateAccountAndPassword(isLogin: false, account: account, password: password, reEnterPassword: reEnterPassword)
        
        if infoAlert.1 != .success {
            FMobileAlert.bannerAlertView(view: self.view, title: infoAlert.0, status: infoAlert.1)
            return
        }
        
        if requireAcceptPolicy {
            if !isPolicy {
                FMobileAlert.bannerAlertView(view: self.view, title: "Bạn chưa đồng ý với điều khoản và chính sách sử dụng của chúng tôi", status: .waring)
                return
            }
        }
        
        print("SUCCESS ACCOUNT AND PASSWORD")
        FMobile.instace().authManager.register(with: account, password, referalCode)
    }
    
    @objc
    private func onClickViewImageRemember(_ sender: UITapGestureRecognizer?){
        isPolicy.toggle()
        imageTermsOfUse.tintColor = isPolicy ? UIColor.hyperLink : UIColor.divider
        imageTermsOfUse.image = UIImage(systemName: isPolicy ? "checkmark.square.fill" : "square")
    }
    
    @objc func showThePasswordViewController() {
        setupView()
    }
    
    @objc
    private func onClickViewLoginShowPassword(_ sender: UITapGestureRecognizer?){
        
        isShowPassword.toggle()
        imgShowPassword.image = UIImage(systemName: isShowPassword ? "eye.slash.fill" :"eye.fill")
        tfPassword.isSecureTextEntry = isShowPassword
    }
    
    
    @objc
    private func onClickViewLoginShowReEnterPassword(_ sender: UITapGestureRecognizer?){
        
        isShowReEnterPassword.toggle()
        imgShowReEnterPassword.image = UIImage(systemName: isShowReEnterPassword ? "eye.slash.fill" :"eye.fill")
        tfReEnterPassword.isSecureTextEntry = isShowReEnterPassword
    }
    
    @objc
    private func onClickViewBack(_ sender: UITapGestureRecognizer?){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func onClickTermsOfUse(_ sender: UITapGestureRecognizer?){
        let vc = TermsOfUseViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionRegister(_ sender: Any) {
        validateRegister()
    }
    
}
