//
//  WelcomeVM.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 02/03/2022.
//

import UIKit
class WelcomeVM {
    func checkToken() {
        if let token = userDefault.string(forKey: "Token"), token.isEmpty == false {
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let  tabbarVC = storyboard.instantiateViewController(withIdentifier: TabBaViewController.nameClass)
            UIApplication.shared.keyWindow?.rootViewController = tabbarVC
        }
    }
}

