// The Swift Programming Language
// https://docs.swift.org/swift-book
import UIKit


internal func moduleLog(_ message: Any...){
    if FMobile.instace().logEnable {
        print(message)
    }
}

open class FMobile: NSObject {
    
    private static var shared = FMobile()
    
    internal var logEnable: Bool = false
    
    
    private override init() { }
    
    public static func instace() -> FMobile {
        return shared
    }
   
    public var authManager: AuthManager {
        AuthManager.instace()
    }
    
//    public var sytemManager: SystemManager {
//        SystemManager.instace()
//    }
//    
//    public var themeManager: ThemeManager {
//        ThemeManager.instace()
//    }
    
    public func setLogEnable(isEnable: Bool) {
        logEnable = isEnable
    }
}
