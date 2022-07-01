//
//  LoginVM.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 02/03/2022.
//

import UIKit

class LoginVM: NSObject {
    
    func loginVm(newLogin: Login, action: ((String) -> Void)? = nil) {
        ServiceAPI.share.checkLogin(newLogin: newLogin) { response, error in
                let messDialog = error
                let checkLogin = response
                if checkLogin == true {
                    action?("")
                } else {
                    if messDialog == "BAD REQUEST" {
                        action?("Tên đăng nhập hoặc tài khoản không đúng")
                    } else {
                        action?(messDialog)
                    }
                }
        }
    }
    
    func checkDataLogin(name: String, pass: String) -> Bool {
        return !name.isEmpty && !pass.isEmpty
    }
}
