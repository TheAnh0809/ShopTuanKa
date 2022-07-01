//
//  CartVM.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 03/03/2022.
//

import UIKit
struct CheckCart {
    var id: Int = 0
    var check: Bool = true
}
class CartVM: NSObject {
    var listCheck: [CheckCart] = []
    var listCart: [ItemOfCart] = []
    func loadCard(action: (() -> Void)? = nil) {
        ServiceAPI.share.getCartOfMe { response, error in
            if let response = response {
                DispatchQueue.main.sync {
                    self.listCart = response
                    self.listCheck = []
                    for item in self.listCart {
                        self.listCheck.append(CheckCart(id: item.cartId, check: true))
                    }
                    action?()
                }
            }
            if error != nil {
                showDialogAtBaseView(title: "Lỗi", messenger: "Tài khoản đăng nhập hết hạn", button: "Ok")
            }
        }
    }
}
