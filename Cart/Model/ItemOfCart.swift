//
//  Cart.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 19/02/2022.
//

import UIKit
class ItemOfCart {
    var cartId: Int = 0
    var productId: Int = 0
    var quantity: Int = 0
    var imgURL: String = ""
    var title: String = ""
    var price: Int = 0
    var size: Int = 0
    func initLoad(_ json: [String: Any]) {
        cartId =  json["cartId"] as? Int ?? 0
        productId =  json["productId"] as? Int ?? 0
        quantity =  json["quantity"] as? Int ?? 0
        imgURL =  json["imgURL"] as? String ?? ""
        title =  json["title"] as? String ?? ""
        price =  json["price"] as? Int ?? 0
        size =  json["size"] as? Int ?? 0
    }
}
