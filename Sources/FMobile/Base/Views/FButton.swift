//
//  FButton.swift
//  FTechSDK
//
//  Created by QuangAnh on 30/10/24.
//

import UIKit

internal class FButton: UIButton {
    
}
class SocialButton: UIImageView {
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    init() {
        super.init(frame: .zero)
//        self.alertAction = alertAction
        self.commonInit()
    }
    
//    init(alertAction: TIOAlertAction?) {
//        super.init(frame: .zero)
////        self.alertAction = alertAction
//        self.commonInit()
//    }
    deinit {

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        
        
    }
}



