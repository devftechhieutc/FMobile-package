//
//  FMobileValidate.swift
//  FMobile
//
//  Created by Tran Hieu on 21/11/24.
//

import UIKit

struct FMobileValidate {
    
    static func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{9,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    static func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    static func isValidUpperCase(password: String) -> Bool {
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: password)
        return capitalresult
    }
    
    static func isValidNumberRegEx(password: String) -> Bool {
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: password)
        return numberresult
    }
    
    
    static func usValidSpecialCharacter(password: String) -> Bool {
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let specialresult = texttest2.evaluate(with: password)
        return specialresult
    }
    
    static func validateAccountAndPassword(isLogin: Bool, account: String, password: String, reEnterPassword: String) -> (String, StatusBanner) {
        
        let configs = FMobileConfig.getModuleConfig(isLogin ? .loginAccount : .registerAccount)?.configs
        let validatePhone = configs?.validateAccountPhone ?? false
        
        let validateEmail = configs?.validateAccountEmail ?? false
        
        let validatePassword = configs?.validatePassword ?? false
        
        if validateEmail {
            if  account == ""  {
                return ("Email không được bỏ trống", .fail)
            }
            
            if !(FMobileValidate.isValidEmail(email: account)) {
                return ("Email không đúng định dạng", .waring)
            }
        }
        
        if validatePhone {
            if  account == ""  {
                return ("Số điện thoại không được bỏ trống", .fail)
            }
            if !(FMobileValidate.isValidPhone(phone: account)) {
                return ("Số điện thoại không đúng định dạng", .waring)
            }
        }
        
        if validatePassword {
            let passwordMinLength = configs?.passwordMinLength ?? 0
            let passwordHasNumber = configs?.passwordHasNumber ?? false
            let passwordHasUppercase = configs?.passwordHasUppercase ?? false
            let passwordHasSpecialChar = configs?.passwordHasSpecialChar ?? false
            let requireRePassword = configs?.requireRePassword ?? true
            
            if (password.count) <= passwordMinLength {
                return ("mật khẩu ít nhất \(passwordMinLength) ký tự", .waring)
            }
            
            if passwordHasNumber {
                if !FMobileValidate.isValidNumberRegEx(password: password) {
                    return ("mật khẩu ít nhất phải có 1 chữ số", .waring)
                }
            }
            
            if passwordHasUppercase {
                if !FMobileValidate.isValidUpperCase(password: password) {
                    return ("mật khẩu ít nhất phải có 1 chữ viết hoa", .waring)
                }
                
            }
            
            if passwordHasSpecialChar {
                if !FMobileValidate.usValidSpecialCharacter(password: password) {
                    return ("mật khẩu ít nhất phải có 1 kí tự đặc biệt", .waring)
                }
            }
            
            if !isLogin {
                if requireRePassword {
                    if reEnterPassword.count <= passwordMinLength {
                        return ("mật khẩu nhập lại nhất \(passwordMinLength) ký tự", .waring)
                    }
                    
                    if passwordHasNumber {
                        if !FMobileValidate.isValidNumberRegEx(password: reEnterPassword) {
                            return ("mật khẩu nhập lại ít nhất phải có 1 chữ số", .waring)
                        }
                    }
                    
                    if passwordHasUppercase {
                        if !FMobileValidate.isValidUpperCase(password: reEnterPassword) {
                            return ("mật khẩu nhập lại ít nhất phải có 1 chữ viết hoa", .waring)
                        }
                    }
                    
                    if passwordHasSpecialChar {
                        if !FMobileValidate.usValidSpecialCharacter(password: reEnterPassword) {
                            return ("mật khẩu nhập lại ít nhất phải có 1 kí tự đặc biệt", .waring)
                        }
                    }
                    
                    if password != reEnterPassword {
                        return ("mật khẩu không giống nhau", .waring)
                    }
                }
            }
            
        }
        return ("", .success)
    }
    
}
