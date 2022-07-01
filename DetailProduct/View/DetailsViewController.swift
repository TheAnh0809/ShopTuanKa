//
//  ProductDetailsViewController.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 07/02/2022.
//

import UIKit

@available(iOS 13.0, *)
class DetailsViewController: BaseViewController {
    @IBOutlet weak var TBVDetailProduct: UITableView!
    var detailVM: DetailVM = DetailVM()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TBVDetailProduct.registerListCell(list: ([StarCell.self, DetailCell.self, SearchShoesCell.self] ))
        detailVM.getListRelate {
            self.TBVDetailProduct.reloadData()
        }
        UITableView.automaticDimension
        navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = "Thông tin sản phẩm"
    }

    @IBAction func clickBuyNow(_ sender: Any) {
        self.pushView(storybard: UIStoryboard(name: "TabBar", bundle: nil),
                      nextView: ChosesSizeVCL.self) { view in
            view.sizeVM.mainProduct.product = (self.detailVM.mainProduct as? Product)!
            view.sizeVM.gear = .buyNow
        }
    }
    @IBAction func clickAddToBasket(_ sender: Any) {
        self.pushView(storybard: UIStoryboard(name: "TabBar", bundle: nil), nextView: ChosesSizeVCL.self) { view in
            view.sizeVM.mainProduct.product = (self.detailVM.mainProduct as? Product)!
        }
    }
}
@available(iOS 13.0, *)
extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailVM.listRelate.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0 :
            let cell = TBVDetailProduct.dequeueReusableCell(withIdentifier: "StarCell", for: indexPath) as? StarCell
            cell!.fillData(detailVM.mainProduct)
            return cell!
        case 1 :
            let cell = TBVDetailProduct.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as? DetailCell
            cell?.actionBlock = {
                if cell?.lookMore == true {
                    cell?.lookMore = false
                    cell?.lableDetail.lineBreakMode = .byWordWrapping
                    cell?.lableDetail.numberOfLines = 3
                } else {
                    cell?.lookMore = true
                    cell?.lableDetail.lineBreakMode = .byWordWrapping
                    cell?.lableDetail.numberOfLines = 0
                }
                self.TBVDetailProduct.reloadData()
            }
            cell!.fillData(detailVM.mainProduct)
            return cell!
        default:
            let cell = TBVDetailProduct.dequeueReusableCell(withIdentifier: "SearchShoesCell", for: indexPath)
            as? SearchShoesCell
            cell?.filldata(detailVM.listRelate[indexPath.row - 2])
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0, 1: break
        default:
            detailVM.replaceProduct(index: indexPath.row - 2)
            TBVDetailProduct.reloadData()
        }
    }
}
