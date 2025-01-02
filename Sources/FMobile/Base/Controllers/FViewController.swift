//
//  FViewController.swift
//  FTechSDK
//
//  Created by QuangAnh on 30/10/24.
//
import UIKit
class FViewController: UIViewController, ThemeManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        FMobile.instace().themeManager.add(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
     
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
//    deinit {
//        FMobile.instace().themeManager.remove(delegate: self)
//    }
    
    func didChangeTheme() {
        
    }
    
}
