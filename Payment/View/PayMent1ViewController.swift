//
//  PayMent1ViewController.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 08/02/2022.
//

import UIKit

class PayMent1ViewController: BaseViewController {
    var isOrder: Bool = false
    var payVM: PaymentVM = PaymentVM()
    @IBOutlet weak var btnThanhToan: UIButton!
    @IBOutlet weak var tbvShow: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnThanhToan.clipsToBounds = true
        btnThanhToan.layer.cornerRadius = 15
        btnThanhToan.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        if isOrder == true {
            btnThanhToan.isHidden = true
            navigationItem.title = "Đơn đã mua"
        } else {
            navigationItem.title = "Thanh Toán"
            payVM.getdata {
                self.tbvShow.reloadData()
                if self.payVM.dataCheck.address.isEmpty == true {
                    self.pushView(storybard: UIStoryboard(name: "TabBar", bundle: nil),
                                  nextView: AddressViewController.self)
                }
            }
        }
        tbvShow.registerListCell(list: [PayCell.self, TotalPricePayCell.self])
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isOrder == false {
            payVM.getdata {
                self.tbvShow.reloadData()
            }
        }
        
    }
    @IBAction func cliclPay(_ sender: Any) {
        if payVM.dataCheck.address.isEmpty == true {
            showDiglog(title: "Lỗi", messenger: "Chưa đăng ký địa chỉ nhận hàng", button: "Ok")
        } else {
            showLoading()
            payVM.paymentData {
                self.dismisLoading()
                self.pushView(storybard: UIStoryboard(name: "TabBar", bundle: nil),
                              nextView: PaySuccecViewController.self)
            }
        }
    }
}
extension PayMent1ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case payVM.dataCheck.listItem.count:
            return CGFloat(140 + payVM.dataCheck.address.count/40*45)
        default:
            return tbvShow.frame.height/1.5
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payVM.dataCheck.listItem.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case payVM.dataCheck.listItem.count:
            let cell = tbvShow.dequeueReusableCell(withIdentifier: "TotalPricePayCell",
                                                   for: indexPath) as? TotalPricePayCell
            cell?.fillData(payVM.dataCheck)
            cell?.callBack = {
                if self.isOrder == false {
                    self.pushView(storybard: UIStoryboard(name: "TabBar", bundle: nil),
                                  nextView: AddressViewController.self)
                }
            }
            return cell!
        default:
            let cell = tbvShow.dequeueReusableCell(withIdentifier: "PayCell", for: indexPath) as? PayCell
            cell?.fillData(payVM.dataCheck.listItem[indexPath.row])
            return cell!
        }
    }
}
