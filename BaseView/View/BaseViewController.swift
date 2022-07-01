//
//  BaseViewController.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 10/02/2022.
//

import UIKit
import JGProgressHUD
var userDefault = UserDefaults.standard
class BaseViewController: UIViewController {
    let hud = JGProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()
        // ten cua nut back
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // Mau cua nut
        self.navigationController?.navigationBar.tintColor = baseColor
        // mau của title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: baseColor]
            //
        
        // Do any additional setup after loading the view.
    }
    func showLoading(_ text: String? = nil) {
        let text = text == nil ? "Loading..." : text
        hud.textLabel.text = text
        hud.show(in: self.view)
    }
    func dismisLoading() {
        hud.dismiss(animated: true)
    }
}
