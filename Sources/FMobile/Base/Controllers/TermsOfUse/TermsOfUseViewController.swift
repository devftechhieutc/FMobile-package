//
//  TermsOfUseViewController.swift
//  FMobile
//
//  Created by Tran Hieu on 21/11/24.
//

import UIKit
import WebKit

class TermsOfUseViewController: FViewController {
    
    @IBOutlet weak var imageBack: UIImageView!
    
    @IBOutlet weak var webPolicy: WKWebView!
    
    let urlPolicy = FMobileConfig.getModuleConfig(.registerAccount)?.configs.urlPolicy
    
    init() {
        super.init(nibName: "TermsOfUseViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageBack.image = UIImage(systemName: "arrow.left")
        imageBack.tintColor = UIColor.textHint
        
        imageBack.isUserInteractionEnabled = true
        imageBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClickViewBack)))
        if let url = urlPolicy {
            let myURL = URL(string: url)
            let myRequest = URLRequest(url: myURL!)
            webPolicy.load(myRequest)
        }
        
    }
    
    @objc
    private func onClickViewBack(_ sender: UITapGestureRecognizer?){
      
        self.navigationController?.popViewController(animated: true)
    }
}
