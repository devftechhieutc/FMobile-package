//
//  SystemManager.swift
//  FTechSDK
//
//  Created by QuangAnh on 30/10/24.
//
protocol SystemManagerDelegate {
    
}

public class SystemManager {
    private var delegate = MulticastDelegate<SystemManagerDelegate>()
    
    private static var shared = SystemManager()
    
    public static func instace() -> SystemManager {
        return shared
    }
    
    public func referralCode(isEnable: Bool) {
        FMobileConfig.getModuleConfig(.registerAccount)?.configs.enableRefCode = isEnable
    }
    
    public func policyRegister(isEnable: Bool) {
        FMobileConfig.getModuleConfig(.registerAccount)?.configs.requireAcceptPolicy = isEnable
    }
    

    
}
