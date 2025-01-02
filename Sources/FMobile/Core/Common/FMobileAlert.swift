//
//  FMobileAlert.swift
//  FMobile
//
//  Created by Tran Hieu on 15/11/24.
//
import UIKit

internal enum StatusBanner {
    case success
    case waring
    case fail
}

struct FMobileAlert {
    static func bannerAlertView(view: UIView, title: String, status: StatusBanner) {
        let customView = UIView()
        
        view.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            customView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            customView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            customView.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        let imageBanner = UIImageView()
        customView.addSubview(imageBanner)
        imageBanner.tintColor = UIColor.backgroundPrimary
        
        imageBanner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageBanner.topAnchor.constraint(equalTo: customView.topAnchor, constant: 12),
            imageBanner.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 16),
            imageBanner.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -12),
            imageBanner.heightAnchor.constraint(equalToConstant: 24),
            imageBanner.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        let labelBanner = UILabel()
        labelBanner.textColor = UIColor.backgroundPrimary
        labelBanner.font = UIFont.systemFont(ofSize: 16)
        labelBanner.text = title
        labelBanner.numberOfLines = 0
        customView.addSubview(labelBanner)
        labelBanner.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelBanner.topAnchor.constraint(equalTo: customView.topAnchor, constant: 0),
            labelBanner.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: 16),
            labelBanner.leadingAnchor.constraint(equalTo: imageBanner.trailingAnchor, constant: 8),
            labelBanner.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: 0),
            
        ])
        
        switch status {
        case .success:
            customView.backgroundColor = UIColor.success
            imageBanner.image = UIImage(systemName: "checkmark.circle.fill")
        case .waring:
            customView.backgroundColor = UIColor.warning
            imageBanner.image = UIImage(systemName: "exclamationmark.circle.fill")
        case .fail:
            customView.backgroundColor = UIColor.error
            imageBanner.image = UIImage(systemName: "exclamationmark.triangle.fill")
        }
        
        view.showToast(customView, duration: 2.0, position: .center)
        
    }
}
