//
//  CartViewController.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 08/02/2022.
//

import UIKit

@available(iOS 13.0, *)
class CartViewController: BaseViewController {
    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var tbvCart: UITableView!
    var cardVM: CartVM = CartVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Giỏ hàng"
        tbvCart.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        btnBuy.clipsToBounds = true
        btnBuy.layer.cornerRadius = 15
        btnBuy.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        // Do any additional setup after loading the view.
        showLoading()
        cardVM.loadCard { [self] in
            dismisLoading()
            tbvCart.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoading()
        cardVM.loadCard { [self] in
            dismisLoading()
            tbvCart.reloadData()
        }
        tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func clickPay(_ sender: Any) {
        var listCheck: [Int] = []
        if cardVM.listCart.isEmpty == false {
            for index in 0...cardVM.listCheck.count - 1 {
                if cardVM.listCheck[index].check == true {
                    listCheck.append(cardVM.listCheck[index].id)
                }
            }
            if listCheck.isEmpty == false {
                pushView(storybard: UIStoryboard(name: "TabBar", bundle: nil),
                              nextView: PayMent1ViewController.self) { view in
                    view.payVM.listCheck = listCheck
                }
            } else {
                self.showDiglog(title: "Lỗi", messenger: "Vui lòng chọn sản phẩm muốn thanh toán.", button: "Ok")
            }
        } else {
            self.showDiglog(title: "Lỗi", messenger: "Vui lòng chọn sản phẩm muốn thanh toán.", button: "Ok")
        }
        
    }
    
}
@available(iOS 13.0, *)
extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tbvCart.frame.height/4.2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardVM.listCart.count
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvCart.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? CartCell
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        cell?.fillData(cardVM.listCart[indexPath.row])
        cell?.check = cardVM.listCheck[indexPath.row].check
        cell?.actionBlock = {
            if cell?.check == true {
                cell?.check = false
                self.cardVM.listCheck[indexPath.row].check = false
            } else {
                cell?.check = true
                self.cardVM.listCheck[indexPath.row].check = true
            }
        }
        
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushView(storybard: UIStoryboard(name: "TabBar", bundle: nil), nextView: ChosesSizeVCL.self) { view in
            let data = self.cardVM.listCart[indexPath.row]
            view.sizeVM.mainProduct.product.id = data.productId
            view.sizeVM.quantity = data.quantity
            view.sizeVM.size = data.size
            view.sizeVM.idProductOfCard = data.cartId
            view.sizeVM.gear = .editCard
        }
    }

}
