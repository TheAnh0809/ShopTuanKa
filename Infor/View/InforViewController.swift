//
//  InforViewController.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 08/02/2022.
//

import UIKit

class InforViewController: BaseViewController {

    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var tbvShow: UITableView!
    var user: ProfileUser = ProfileUser()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Cài đặt"
        btnLogout.layer.cornerRadius = 12
        tabBarController?.tabBar.isHidden = true
        tbvShow.registerListCell(list: [InforCell.self, FunctionCell.self])
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    @IBAction func clickLogout(_ sender: Any) {
        tokendated()
    }
}
extension InforViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tbvShow.dequeueReusableCell(withIdentifier: "InforCell",
                                                       for: indexPath) as? InforCell
            cell?.fillData(user)
            cell?.actionChangePass = {
                self.showTextLogChangePass(title: "Đổi mật khẩu", mess: "Nhập đầy đủ thông tin")
            }
            cell?.actionEdit = {
                self.showTextChangeName(oldName: self.user.fullName)
            }
            return cell!
        default:
            let cell = tbvShow.dequeueReusableCell(withIdentifier: "FunctionCell",
                                                       for: indexPath) as? FunctionCell
            cell?.actionAddress = {
                self.pushView(storybard: UIStoryboard(name: "TabBar", bundle: nil),
                              nextView: AddressViewController.self)
            }
            cell?.actionHistory = {
                self.navigationController?.popViewController(animated: true)
            }
            return cell!
        }
    }
}
