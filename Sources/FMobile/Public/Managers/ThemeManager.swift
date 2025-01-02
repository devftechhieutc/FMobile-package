//
//  ThemeManager.swift
//  FTechSDK
//
//  Created by QuangAnh on 30/10/24.
//
public protocol ThemeManagerDelegate {
    func didChangeTheme()
    
}
public class ThemeManager {
    private var themeDelegate = MulticastDelegate<ThemeManagerDelegate>()
    
    static var shared = ThemeManager()
    
    static func instace() -> ThemeManager {
        return shared
    }
    
    private var currentTheme: AppTheme!
    
    public func add(delegate: ThemeManagerDelegate) {
        self.themeDelegate.add(delegate)
    }
    
    public func remove(delegate: ThemeManagerDelegate){
        self.themeDelegate.remove(delegate)
    }
    
    func set(theme: AppTheme){
        currentTheme = theme
        themeDelegate.invoke { delegate in
            delegate.didChangeTheme()
        }
    }
}
