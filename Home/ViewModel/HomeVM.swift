//
//  HomeVM.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 02/03/2022.
//

import UIKit
struct DataCache {
    var key: Int = 0
    var list: [Product] = []
    var page: Int = 0
}
class HomeVM: NSObject {
    var listBrands: [Brand] = []
    var listProduct: [Product]  = []
    var listDataRestore: [DataCache] = []
    var page = 0
    var brandChose: Int = -1
    func checkIdOfDataCache(id: Int) -> Bool {
        for item in listDataRestore {
            if item.key == id {
                return true
            }
        }
        return false
    }
    func getListOfDataCache(id: Int) -> [Product] {
        for item in listDataRestore {
            if item.key == id {
                return item.list
            }
        }
        return []
    }
    func getProductVM(action: (() -> Void)? = nil) {
        listProduct = []
        page = 0
        if checkIdOfDataCache(id: brandChose) == false {
            ServiceAPI.share.getProduct(idBrand: brandChose, page: page) { listProduct, error in
                DispatchQueue.main.async {
                    if listProduct != nil {
                        self.listProduct = listProduct!
                        let newData = DataCache(key: self.brandChose, list: listProduct!, page: self.page)
                        self.listDataRestore.append(newData)
                        action?()
                    }
                    if error != nil {
                        showDialogAtBaseView(title: "Lỗi", messenger: "Bạn cần đăng nhập lại", button: "Ok") {
                            tokendated()
                        }
                    }
                    
                }
            }
        } else {
            listProduct = getListOfDataCache(id: brandChose)
            action?()
        }
        
    }
    func getMoreProduct(action: (() -> Void)? = nil) {
        ServiceAPI.share.getProduct(idBrand: brandChose, page: page) { listProduct, error in
            DispatchQueue.main.async {
                if listProduct != nil {
                    if listProduct?.isEmpty == true {
                        self.page -= 1
                        return
                    } else {
                        self.listProduct += listProduct!
                        action?()
                    }
                }
                if error != nil {
                    showDialogAtBaseView(title: "Lỗi", messenger: "Bạn cần đăng nhập lại", button: "Ok") {
                        tokendated()
                    }
                }
            }
        }
    }
    func getBrandVM(action: (() -> Void)? = nil) {
        ServiceAPI.share.getBrands { listBrands, error in
            if let listBrands = listBrands {
                DispatchQueue.main.async {
                    self.listBrands = listBrands
                    if self.listBrands.isEmpty != true {
                        action?()
                    }
                    
                }
            }
            if let error = error {
                showDialogAtBaseView(title: "Lỗi", messenger: error.errorDescription!, button: "Ok") {
                    tokendated()
                }
            }
        }
    }
}
