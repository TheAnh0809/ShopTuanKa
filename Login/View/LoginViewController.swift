//
//  DangNhap_ViewController.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 21/01/2022.
//

import UIKit

enum MainStoryboard: String {
    case main = "Main"
    case tabbar = "TabBar"
    
    var getStoryboard: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
    
}

class LoginViewController: BaseViewController, UITextFieldDelegate {
    @IBOutlet weak var stackViewLogin: UIStackView!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var textPassWord: UITextField!
    @IBOutlet weak var textUserName: UITextField!
    
    private var loginVM: LoginVM = LoginVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnLogin.layer.cornerRadius = 10
        
        navigationItem.title = "Đăng nhập"
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        [textUserName, textPassWord].forEach { textField in
            textField?.layer.borderWidth = 1
            textField?.layer.borderColor = UIColor.gray.cgColor
        }
        
        textUserName.setDefautText(text: "Tên đăng nhập", color: UIColor.lightGray)
        textPassWord.setDefautText(text: "Mật khẩu", color: UIColor.lightGray)
        
        textPassWord.delegate = self
        textUserName.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func clickDangNhap(_ sender: Any) {
        
        let name = textUserName.text!
        let pass = textPassWord.text!
        
        if name.isEmpty {
            showNotifire(textField: textUserName)
        }
        
        if pass.isEmpty {
            showNotifire(textField: textPassWord)
        }
        
        if loginVM.checkDataLogin(name: name, pass: pass) {
            showLoading()
            let newLogin = Login(userName: textUserName.text!, passWord: textPassWord.text!)
            loginVM.loginVm(newLogin: newLogin) { [weak self] message in
                DispatchQueue.main.async {
                    self?.dismisLoading()
                    if message.isEmpty {
                        let home = MainStoryboard.tabbar.getStoryboard.instantiateInitialViewController()
                        UIApplication.shared.keyWindow?.rootViewController = home
                    } else {
                        showDialogAtBaseView(title: "Đăng nhập lỗi.", messenger: message, button: "OK")
                    }
                }
            }
        }
    }
    
    @IBAction func clickDangKy(_ sender: Any) {
        guard let storyboard = self.storyboard else {
            return
        }
        let registerVC = storyboard.instantiateViewController(withIdentifier: RegisterViewController.nameClass)
        self.navigationController?.setViewControllers([registerVC], animated: false)
        
    }
    
    func showNotifire(textField: UITextField) {
        let text = textField == textUserName ? "Ho va ten" : "Mat khau"
        textField.layer.borderColor = UIColor.red.cgColor
        textField.setDefautText(text: text, color: .red)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            textField.setDefautText(text: text, color: UIColor.lightGray)
            textField.layer.borderColor = UIColor.gray.cgColor
        }
    }
}
