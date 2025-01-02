//
//  FTextField.swift
//  FTechSDK
//
//  Created by QuangAnh on 30/10/24.
//

import UIKit

internal class FTextField: FView {
    private let viewBackGround: UIView = {
        let view = UIView()
        
        return view
    }()
    
    
    private let iconTextField: UIImageView = {
        let icon = UIImageView()
        
        return icon
    }()
    
    private let textFiled: UITextField = {
        let tfiled = UITextField()
        
        return tfiled
    }()
    
    private let iconShowPassword: UIImageView = {
        let icon = UIImageView()
        
        return icon
    }()
    
    override func setup() {
        
    }
    
}

