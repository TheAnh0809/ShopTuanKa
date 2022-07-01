//
//  DangKi_ViewController.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 21/01/2022.
// chuyển thành tableView

import UIKit
import SwiftUI

class RegisterViewController: BaseViewController, UITextFieldDelegate {
    @IBOutlet weak var registerTable: UITableView!
    var resVM: RegisterVM = RegisterVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.title = "Đăng ký"
        self.registerTable.separatorColor = .clear
        registerTable.registerListCell(list: [RegisterCell.self, FooterRegisterCell.self, HeaderRegisterCell.self])
    }
    
    @objc private func clickDangKy(_ sender: Any) {
        if checkAgainPass() == true && checkNillValua() == true {
            resVM.registerAccout {
                self.dismisLoading()
            }
        }
    }
    
    @objc private func clickDangNhap(_ sender: Any) {
        guard let storyboard = self.storyboard else {
            return
        }
        let loginVC = storyboard.instantiateViewController(withIdentifier: LoginViewController.nameClass)
        self.navigationController?.setViewControllers([loginVC], animated: false)
    }
    
    // func
    func checkNillValua() -> Bool {
        for index in 0...5 {
            let cell = self.registerTable.cellForRow(at: IndexPath(row: index, section: 0)) as? RegisterCell
            if cell?.textFrield.text?.isEmpty == true {
                cell!.textFrield.layer.borderColor = baseColor.cgColor
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    cell!.textFrield.layer.borderColor = UIColor.gray.cgColor
                }
                return false
            }
        }
        return true
    }
    func checkAgainPass() -> Bool {
        let cellPass: RegisterCell = (self.registerTable.cellForRow(at: IndexPath(row: 4, section: 0))
                                      as? RegisterCell)!
        let cellAgainPass: RegisterCell = (self.registerTable.cellForRow(at: IndexPath(row: 5, section: 0))
                                           as? RegisterCell)!
        if cellPass.textFrield.text == cellAgainPass.textFrield.text {
            return true
        } else {
            cellAgainPass.showError(error: "Mật khẩu không trùng khớp")
            return false
        }
    }
}
extension RegisterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resVM.listRegister.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeaderRegisterCell.nameClass)
        return cell?.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerRegisterCell = tableView.dequeueReusableCell(withIdentifier: FooterRegisterCell.nameClass)
        guard let cell = footerRegisterCell as? FooterRegisterCell else {
            return nil
        }
        cell.btnDangKy.addTarget(self, action: #selector(self.clickDangKy(_:)), for: .touchUpInside)
        cell.btnDangNhap.addTarget(self, action: #selector(self.clickDangNhap(_:)), for: .touchUpInside)
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterCell") as? RegisterCell else {
            return UITableViewCell()
        }
        cell.textFrield.setDefautText(text: self.resVM.listRegister[indexPath.row].rawValue, color: .lightGray)
        let data = resVM.listRegister[indexPath.row]
        if data == .pass || data == .againPass {
            cell.textFrield.isSecureTextEntry = true
        } else if data == .phone {
            cell.textFrield.keyboardType = .numberPad
        }
        cell.formData = data
        cell.actionBlock = { [weak self] inputText in
            guard let strongSelf = self else {
                return
            }
            switch data {
            case .nameu :
                strongSelf.resVM.newUser.fullName = inputText
            case .userName :
                strongSelf.resVM.newUser.userName = inputText
            case .email:
                strongSelf.resVM.newUser.email = inputText
            case .phone:
                strongSelf.resVM.newUser.phone = inputText
            case .pass:
                strongSelf.resVM.newUser.pass = inputText
            case .againPass :
                break
            }
        }
        return cell
    }
    
}
