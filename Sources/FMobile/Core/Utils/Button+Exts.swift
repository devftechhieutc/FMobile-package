//
//  File.swift
//  
//
//  Created by Ishipo on 11/8/24.
//

import Foundation
import UIKit
import SDWebImage

extension UIButton {
    
    func loadImage(module: ModuleConfig?, imageSet: ImageSet?) {
        guard let moduleConfig = module else { return }
        
        guard let status = moduleConfig.moduleStatus else { return }
        
        guard let image = imageSet else { return }
        
        let urlString: String
        switch status {
        case .hidden:
            urlString = ""
            self.isHidden = true
        case .enable:
            urlString = image.normal ?? ""
        case .disable:
            urlString = image.disable ?? ""
        case .promotion:
            urlString = image.promotion ?? ""
      
        }
        guard let url = URL(string: urlString) else {
            return
        }
        self.sd_setImage(with: url, for: .normal)
    
    }
}
extension UIImageView {
    
    func loadImage(module: ModuleConfig?, imageSet: ImageSet?) {
        guard let moduleConfig = module else { return }
        
        guard let status = moduleConfig.moduleStatus else { return }
        
        guard let image = imageSet else { return }
        
        let urlString: String
        switch status {
        case .hidden:
            urlString = ""
            self.isHidden = true
        case .enable:
            urlString = image.normal ?? ""
        case .disable:
            urlString = image.disable ?? ""
        case .promotion:
            urlString = image.promotion ?? ""
      
        }
        guard let url = URL(string: urlString) else {
            return
        }
        self.sd_setImage(with: url)
    
    }
}
