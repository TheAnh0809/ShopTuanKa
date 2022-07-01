//
//  ChooseSizeVM.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 02/03/2022.
//

import UIKit

@available(iOS 13.0, *)
class ChooseSizeVM: NSObject {
    var mainProduct: ProductTotal = ProductTotal()
    var heightOfSizeCLV = 120
    var gear: GearChosesSize = .nomal
    var idProSize = 0
    var size = 0
    var quantity = 0
    var idProductOfCard = 0
    var avaiableQuantity = -1
    func deleteOfCard(action: (() -> Void)? = nil) {
        if idProductOfCard != 0 {
            ServiceAPI.share.deleteFromCard(id: idProductOfCard) { response, error in
                DispatchQueue.main.async {
                    if response != nil {
                        showDialogAtBaseView(title: "Bỏ khỏi giỏ hàng",
                                             messenger: "Bỏ sản phẩm \(self.mainProduct.product.title) khỏi giỏ hàng thành công",
                                             button: "Ok") {
                            action?()
                        }
                    }
                    if let error = error {
                        showDialogAtBaseView(title: "Lỗi", messenger: error.errorDescription!, button: "Ok")
                    }
                }
            }
        }
    }
    func getInforProduct(action: (() -> Void)? = nil) {
        ServiceAPI.share.getProductForId(idPro: mainProduct.product.id) { response, error in
            DispatchQueue.main.async {
                self.mainProduct = response!
                action?()
                if error != nil {
                    showDialogAtBaseView(title: "Thông báo", messenger: "Tài khoản cần đăng nhập lại", button: "OK")
                }
            }
        }
    }
    func updateCard(idCard: Int, idProd: Int, quantity: Int, size: Int, action: (() -> Void)? = nil) {
        if idCard != 0 && idProd != 0 && quantity != 0 && size != 0 {
            ServiceAPI.share.updateProductInCard(idCard: idCard, idProd: idProd, size: size, quantity: quantity) { response, error in
                DispatchQueue.main.async {
                    if response != nil {
                        showDialogAtBaseView(title: "Thành công", messenger: "Chỉnh sửa giỏ hàng thành công", button: "Ok") {
                            action?()
                        }
                    }
                    if let error = error {
                        showDialogAtBaseView(title: "Lỗi", messenger: error.errorDescription!, button: "Ok") {
                            action?()
                        }
                    }
                }
            }
        } else {
            showDialogAtBaseView(title: "Lỗi", messenger: "Sản phẩm bị lỗi", button: "Ok") {
                action?()
            }
        }
    }
    func buyNowProduct(idProduc: Int, action: ((DataCheckOut, [Int]) -> Void)? = nil) {
        var idCardOfProduct: Int = 0
        ServiceAPI.share.getCartOfMe { response, error in
            if let response = response {
                DispatchQueue.main.sync {
                    for item in response {
                        if item.productId == idProduc {
                            idCardOfProduct = item.cartId
                            break
                        }
                    }
                    if idCardOfProduct != 0 {
                        ServiceAPI.share.checkOut(list: [idCardOfProduct]) { response, error in
                            DispatchQueue.main.async {
                                if let response = response {
                                    action?(response, [idCardOfProduct])
                                }
                                if let error = error {
                                    switch error {
                                    case .dataFalse:
                                        showDialogAtBaseView(title: "Lỗi", messenger: error.errorDescription!, button: "Ok")
                                    case .expireToken:
                                        showDialogAtBaseView(title: "Lỗi", messenger: error.errorDescription!, button: "Ok") {
                                            tokendated()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if error != nil {
                showDialogAtBaseView(title: "Lỗi", messenger: "Tài khoản đăng nhập hết hạn", button: "Ok")
            }
        }
    }
}
