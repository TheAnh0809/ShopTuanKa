//
//  RegisterVM.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 02/03/2022.
//

import UIKit

class RegisterVM: NSObject {
    var newUser: User = User(fullName: "", userName: "", email: "", phone: "", pass: "")
    var listRegister: [Register] = [.nameu, .userName, .email, .phone, .pass, .againPass]
    var listRespone: [ResponErrorRegister] = []
    func registerAccout(actionCallback: (() -> Void)? = nil) {
        ServiceAPI.share.getRegister(newUser: newUser) { response, error in
            DispatchQueue.main.async {
                actionCallback?()
                let messDialog = error
                let okRegister = response
                if okRegister == false {
                    showDialogAtBaseView(title: "Lỗi đăng ký", messenger: messDialog, button: "Ok")
                } else {
                    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                    let welcome = storyboard.instantiateInitialViewController()
                    UIApplication.shared.keyWindow?.rootViewController = welcome
                }
            }
        }
    }
}
