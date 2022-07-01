//
//  ChaoMung_ViewController.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 20/01/2022.
//

import UIKit

class WelcomeViewController: BaseViewController {
    @IBOutlet weak var lableName: UILabel!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    var welcomeVM : WelcomeVM = WelcomeVM()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        welcomeVM.checkToken()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogin.layer.cornerRadius = 10
        btnRegister.layer.cornerRadius = 10
        print(userDefault.string(forKey: "Token") as Any)
    }
    @IBAction func clickDangNhap(_ sender: Any) {
        self.pushView(storybard: UIStoryboard(name: "Main", bundle: nil), nextView: LoginViewController.self)
    }
    
    @IBAction func clickDangKy(_ sender: Any) {
        self.pushView(storybard: UIStoryboard(name: "Main", bundle: nil), nextView: RegisterViewController.self)
    }
}
