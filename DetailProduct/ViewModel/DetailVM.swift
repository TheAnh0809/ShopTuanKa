//
//  DetailVM.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 02/03/2022.
//

import UIKit

class DetailVM: NSObject {
    var listRelate: [ProductProtocol] = []
    var mainProduct: ProductProtocol!
    func replaceProduct(index: Int) {
        listRelate.append(self.mainProduct)
        mainProduct = listRelate[index]
        listRelate.remove(at: index )
    }
    func getListRelate(action: (() -> Void)? = nil) {
        ServiceAPI.share.getProduct(idBrand: mainProduct.brandId, page: 0) { listProduct, error in
            DispatchQueue.main.async { [self] in
                if let listProduct = listProduct {
                    listRelate = listProduct
                    var list: [ProductProtocol] = []
                    for item in listRelate {
                        if item.id != mainProduct.id {
                            list.append(item)
                        }
                        if list.count == 5 {
                            break
                        }
                    }
                    listRelate = list
                    action?()
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
