//
//  SearchVM.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 02/03/2022.
//

import UIKit

class SearchVM: NSObject {
    var listSearch: [Product] = []
    func searchVM(text: String, action: (() -> Void)? = nil) {
        ServiceAPI.share.getProductSearchName(text: text) { response, error in
            DispatchQueue.main.async { [self] in
                if let response = response {
                    listSearch = response
                    action?()
                }
                if let _ = error {
                    showDialogAtBaseView(title: "Lỗi", messenger: "Bạn cần đăng nhập lại", button: "Ok")
                }
            }
        }
    }
}
