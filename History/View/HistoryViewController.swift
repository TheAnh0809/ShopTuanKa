//
//  HistoryViewController.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 08/02/2022.
//

import UIKit
import Alamofire

class HistoryViewController: BaseViewController {
    @IBOutlet weak var tbvShowData: UITableView!
    var historyVM: HistoryVM = HistoryVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Lịch sử mua hàng"
        // Do any additional setup after loading the view.
        tbvShowData.registerListCell(list: [InforUserCell.self, SearchShoesCell.self])
        historyVM.getInfor {
            self.tbvShowData.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        historyVM.getInfor {
            self.tbvShowData.reloadData()
        }
    }
    @IBAction func clcikSetting(_ sender: Any) {
        pushView(storybard: UIStoryboard(name: "TabBar", bundle: nil), nextView: InforViewController.self) { view in
            view.user = self.historyVM.user
        }
    }
}
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UIScreen.main.bounds.height/2.5
        default:
            return UIScreen.main.bounds.height/8
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyVM.listOrder.count + 1
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tbvShowData.dequeueReusableCell(withIdentifier: "InforUserCell",
                                                       for: indexPath) as? InforUserCell
            cell?.fillData(historyVM.user)
            cell?.lbOrder.text = historyVM.listOrder.count.description
            cell?.actionAvatar = {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            }
            return cell!
        default:
            let cell = tbvShowData.dequeueReusableCell(withIdentifier: "SearchShoesCell",
                                                       for: indexPath) as? SearchShoesCell
            cell?.fillData(historyVM.listOrder[indexPath.row - 1])
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            historyVM.getInforOrder(index: indexPath.row - 1) { data in
                self.pushView(storybard: UIStoryboard(name: "TabBar", bundle: nil),
                              nextView: PayMent1ViewController.self) { view in
                    view.payVM.dataCheck = data
                    view.isOrder = true
                }
            }
        }
        
    }
}
extension HistoryViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        historyVM.uploadAvataVM(image: image) {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
