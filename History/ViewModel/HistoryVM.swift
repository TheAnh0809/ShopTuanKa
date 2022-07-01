//
//  HistoryVM.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 03/03/2022.
//

import UIKit

class HistoryVM: NSObject {
    var user: ProfileUser = ProfileUser()
    var listOrder: [ProductOrdered] = []
    func getInfor(action: (() -> Void)? = nil) {
        ServiceAPI.share.getUser { response, error in
            DispatchQueue.main.sync {
                if let response = response {
                    self.user = response
                }
                if error != nil {
                    showDialogAtBaseView(title: "Thông báo", messenger: "Tài khoản cần đăng nhập lại", button: "Ok") {
                        tokendated()
                    }
                }
            }
        }
        ServiceAPI.share.getOrdered { response, error in
            DispatchQueue.main.sync {
                if let response = response {
                    self.listOrder = response
                    action?()
                }
                if error != nil {
                    showDialogAtBaseView(title: "Thông báo", messenger: error.debugDescription, button: "Ok")
                }
            }
        }
    }
    func uploadAvataVM(image: UIImage, action: (() -> Void)? = nil) {
        ServiceAPI.share.uploadAvata(image: image) { response, error in
            DispatchQueue.main.async {
                if response != nil {
                    action?()
                }
                if let error = error {
                    action?()
                    showDialogAtBaseView(title: "Lỗi", messenger: error.errorDescription!, button: "Ok")
                }
            }
        }
    }
    func getInforOrder(index: Int, action: ((DataCheckOut) -> Void)? = nil) {
        ServiceAPI.share.getDetailOrdered(id: listOrder[index].product.id) { respone, error in
            DispatchQueue.main.async {
                if let respone = respone {
                    action?(respone)
                }
                if let error = error {
                    showDialogAtBaseView(title: "Lỗi", messenger: error.errorDescription!, button: "Ok")
                }
            }
        }
    }
}
