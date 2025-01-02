//
//  AlertViewController.swift
//  FMobile
//
//  Created by Tran Hieu on 15/11/24.
//

import UIKit

class AlertViewController: UIViewController {
    
    private var contentView = UIView()
    private var stContent = UIStackView()
    private var lbTitle = UILabel()
    private var lbMessage = UILabel()
    private var lineView = UIView()
    private var lineViewWidth = UIView()
    
    
    private lazy var stLine: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var stButtons: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var _message: NSAttributedString?
    private var _title: NSAttributedString?
    private var _style: AlertViewController.Style = .alert
    private var _actions: [TIOAlertAction] = []
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: NSAttributedString? = nil, message: NSAttributedString? = nil, preferredStyle: AlertViewController.Style = .alert) {
        super.init(nibName: nil, bundle: nil)
        
        self._message = message
        self._title = title
        self._style = preferredStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black.withAlphaComponent(0.8)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -34)
        ])
        
        layoutStackViewContent()
    }
    
    private func layoutStackViewContent() {
        contentView.addSubview(stContent)
        
        stContent.spacing = 16
        stContent.distribution = .fill
        stContent.axis = .vertical
        
        stContent.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stContent.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stContent.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            stContent.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            stContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        stContent.addArrangedSubview(lbTitle)
        stContent.addArrangedSubview(lbMessage)
        
        lbTitle.attributedText = _title
        lbTitle.textAlignment = .center
        lbTitle.numberOfLines = 0
        
        lbMessage.attributedText = _message
        lbMessage.textAlignment = .center
        lbMessage.numberOfLines = 0
        
        
        
        
        stContent.addArrangedSubview(stLine)
        
        stLine.addArrangedSubview(lineView)
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = UIColor.divider
        
        NSLayoutConstraint.activate([
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        stLine.addArrangedSubview(stButtons)
        
        stButtons.backgroundColor = UIColor.divider
        NSLayoutConstraint.activate([
            stButtons.heightAnchor.constraint(equalToConstant: _actions.isEmpty ? 0 : 44)
        ])
        
        
        
        _actions.forEach { action in
           
            let btn = TIOAlertButton(alertAction: action)
            
            btn.onActionHanler = {[weak self] btn in
                self?.dismiss(animated: true)
            }
            
            stButtons.addArrangedSubview(btn)
        }
        
        
    }
    
    func addAction(_ action: TIOAlertAction) {
        _actions.append(action)
    }
    
    
    func addActions(_ actions: [TIOAlertAction]) {
        _actions = actions
    }
    
    @objc func onDissmisAlert(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
}

fileprivate class TIOAlertButton: UIButton {

    private var alertAction: TIOAlertAction!
    var onActionHanler: ((TIOAlertButton) -> Void)?
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    init(alertAction: TIOAlertAction?) {
        super.init(frame: .zero)
        self.alertAction = alertAction
        self.commonInit()
    }
    
    deinit {

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        self.setTitle(alertAction.title, for: .normal)
       
        switch alertAction.style {
        case .default:
            setTitleColor(UIColor(hex: "1080EC"), for: .normal)
            backgroundColor = .white
            self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            break
        case .cancel:
            setTitleColor(UIColor(hex: "FF4D4D"), for: .normal)
            backgroundColor = .white
            self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium  )
            break
         }
        
        self.isUserInteractionEnabled = true
        self.addTarget(self, action: #selector(onHanlerButton(_:)), for: .touchUpInside)
    }
    
    @objc func onHanlerButton(_ sender: UIButton) {
        alertAction.hanler?(alertAction)
        onActionHanler?(self)
    }
}

class AlertBuilder: NSObject {
    private var _title: NSAttributedString?
    private var _message: NSAttributedString?
    private var _actions : [TIOAlertAction] = []
    
    
    func with(message: NSAttributedString) -> AlertBuilder {
        _message = message
        return self
    }
    
    func with(title: NSAttributedString) -> AlertBuilder {
        _title = title
        return self
    }
    func with(action: TIOAlertAction) -> AlertBuilder {
        _actions.append(action)
        return self
    }
    func show(vc: UIViewController, replace: Bool = false) {
        
        if vc.isKind(of: UIAlertController.self) && replace {
            return
        }
        
        let alert = AlertViewController(title: _title, message: _message, preferredStyle: .alert)
        _actions.forEach { action in
            alert.addAction(action)
        }
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overCurrentContext
        vc.present(alert, animated: true)
    }
}
class TIOAlertAction {
    var title: String?
    var style: TIOAlertAction.Style
    var hanler: ((TIOAlertAction) -> Void)?
    
    init(title: String? = nil, style: TIOAlertAction.Style, hanler: ((TIOAlertAction) -> Void)? = nil) {
        self.title = title
        self.style = style
        self.hanler = hanler
    }
    
    enum Style {
        case `default`
        case cancel
    }
}

extension AlertViewController {
    enum Style: Int {
        case alert = 0
    }
}


