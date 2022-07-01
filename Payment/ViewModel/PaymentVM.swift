//
//  PaymentVM.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 03/03/2022.
//

import UIKit

class PaymentVM: NSObject {
    var dataCheck: DataCheckOut = DataCheckOut()
    var listCheck: [Int] = []
    func getdata(action: (() -> Void)? = nil) {
        if listCheck.isEmpty == false {
            ServiceAPI.share.checkOut(list: listCheck) { response, error in
                DispatchQueue.main.async {
                    if let response = response {
                        self.dataCheck = response
                        action?()
                    } else {
                        showDialogAtBaseView(title: "Lỗi", messenger: (error?.errorDescription)!, button: "Ok")
                    }
                }
            }
        }
    }
    func paymentData(action: (() -> Void)? = nil) {
        ServiceAPI.share.postCheckOutProduct(list: listCheck, address: dataCheck.address) { respone, error in
            DispatchQueue.main.async {
                if respone != nil {
                    action?()
                }
                if error != nil {
                    showDialogAtBaseView(title: "Lỗi", messenger: (error?.errorDescription)!, button: "Ok")
                }
            }
        }
    }
}
