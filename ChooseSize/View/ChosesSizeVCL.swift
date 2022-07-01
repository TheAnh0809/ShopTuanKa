//
//  DetaiProductToBasketViewController.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 07/02/2022.
//

import UIKit
import SwiftUI
@available(iOS 13.0, *)
enum GearChosesSize {
    case nomal
    case buyNow
    case editCard
}
@available(iOS 13.0, *)
class ChosesSizeVCL: BaseViewController {    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var tbvShow: UITableView!
    var sizeVM: ChooseSizeVM = ChooseSizeVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = "Thông tin sản phẩm"
        tbvShow.registerListCell(list: [PriceCell.self, ChoseSizeCell.self, ImageProductCell.self])
        sizeVM.getInforProduct {
            self.tbvShow.reloadData()
        }
        switch sizeVM.gear {
        case .nomal:
            break
        case .buyNow:
            btnNext.backgroundColor = baseColor
            btnNext.setTitle("Mua ngay", for: .normal)
        case .editCard:
            btnNext.backgroundColor = baseColor
            btnNext.setTitle("Chỉnh sửa đơn hàng", for: .normal)
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickNext(_ sender: Any) {
        let cell: ChoseSizeCell = (self.tbvShow.cellForRow(at: IndexPath(row: 2, section: 0))
                                   as? ChoseSizeCell)!
        
        (sizeVM.idProSize, sizeVM.quantity) = cell.returnDataChose()
        if sizeVM.quantity == 0 || sizeVM.idProSize == 0 {
            showDiglog(title: "Lỗi", messenger: "Chọn số lượng và size muốn mua", button: "Ok")
        } else {
            switch sizeVM.gear {
            case .editCard:
                sizeVM.updateCard(idCard: sizeVM.idProductOfCard, idProd: sizeVM.mainProduct.product.id,
                                  quantity: sizeVM.quantity, size: sizeVM.size) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            default:
                showLoading()
                ServiceAPI.share.postProductToCart(idProducSize: sizeVM.idProSize, quatity: sizeVM.quantity) { response, error in
                    DispatchQueue.main.sync { [self] in
                        dismisLoading()
                        if let response = response as? Bool {
                            if response == true {
                                if sizeVM.gear == .nomal {
                                    tabBarController?.selectedIndex = 2
                                    navigationController?.popToRootViewController(animated: true)
                                } else {
                                    self.showLoading()
                                    sizeVM.buyNowProduct(idProduc: sizeVM.mainProduct.product.id) { data, list  in
                                        self.dismisLoading()
                                        self.pushView(storybard: UIStoryboard(name: "TabBar", bundle: nil),
                                                      nextView: PayMent1ViewController.self) { view in
                                            self.tabBarController?.tabBar.isHidden = true
                                            view.payVM.dataCheck = data
                                            view.payVM.listCheck = list
                                        }
                                    }
                                }
                            }
                            if let error = error {
                                self.showDiglog(title: "Lỗi", messenger: error.errorDescription!, button: "Ok")
                            }
                        } else {
                            self.showDiglog(title: "Lỗi", messenger: "Tài khoản cần đăng nhập lại", button: "Ok") {
                                tokendated()
                            }
                        }
                    }
                }
            }
        }
    }
}
@available(iOS 13.0, *)
extension ChosesSizeVCL: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0 :
            return 250
        case 1 :
            return 120
        default :
            return CGFloat(sizeVM.heightOfSizeCLV)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0 :
            let cell = tbvShow.dequeueReusableCell(withIdentifier: "ImageProductCell", for: indexPath)
            as? ImageProductCell
            cell!.fillData(sizeVM.mainProduct.product)
            return cell!
        case 1 :
            let cell = tbvShow.dequeueReusableCell(withIdentifier: "PriceCell", for: indexPath) as? PriceCell
            cell!.fillData(sizeVM.mainProduct)
            if sizeVM.avaiableQuantity >= 0 {
                cell?.lbNumber.text = sizeVM.avaiableQuantity.description
            }
            if sizeVM.gear == .editCard && sizeVM.idProductOfCard != 0 {
                cell?.action = {
                    self.sizeVM.deleteOfCard {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
            return cell!
        default:
            let cell = tbvShow.dequeueReusableCell(withIdentifier: "ChoseSizeCell", for: indexPath) as? ChoseSizeCell
            cell?.fillData(sizeVM.mainProduct.product)
            cell?.action2 = {
                if self.sizeVM.heightOfSizeCLV != 120 + ((cell?.listSize.count)!/4)*40 {
                    self.sizeVM.heightOfSizeCLV = 120 + ((cell?.listSize.count)!/4)*40
                    self.tbvShow.reloadData()
                }
                if self.sizeVM.gear == .editCard {
                    cell?.sizeChoose = self.sizeVM.size
                    cell?.number = self.sizeVM.quantity
                }
            }
            cell?.action3 = {
                self.sizeVM.avaiableQuantity = cell?.avableQuantity ?? -1
                let index = IndexPath(item: 1, section: 0)
                self.tbvShow.reloadRows(at: [index], with: .none)
            }
            return cell!
        }
        
    }
}
