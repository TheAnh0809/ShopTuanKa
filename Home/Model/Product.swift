//
//  Product.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 14/02/2022.
//

import UIKit
class Product: ProductProtocol {
    var id: Int = 0
    var title: String = ""
    var decription: String = ""
    var image: String = ""
    var price: Int = 0
    var star: Int = 0
    var creatAt: String = ""
    var updateAt: String = ""
    var brandId: Int = 0
    func initLoad(_ json: [String: Any]) {
        id =  json["id"] as? Int ?? 0
        title =  json["title"] as? String ?? ""
        decription =  json["description"] as? String ?? ""
        title =  json["title"] as? String ?? ""
        price =  json["price"] as? Int ?? 0
        image =  json["imgURL"] as? String ?? ""
        creatAt =  json["createdAt"] as? String ?? ""
        brandId =  json["brandId"] as? Int ?? 0
        updateAt =  json["updatedAt"] as? String ?? ""
    }
}
class ProductTotal {
    var product: Product = Product()
    var total: Int = 0
    func initLoad(_ json: [String: Any]) {
        product.initLoad(json)
        total = json["total"] as? Int ?? 0
    }
}

class ProductSize {
    var id: Int = 0
    var size: Int = 0
    var availableQuantity: Int = 0
    var creatAt: String = ""
    var updateAt: String = ""
    var productId: Int = 0
    func initLoad(_ json: [String: Any]) {
        id =  json["id"] as? Int ?? 0
        size =  json["size"] as? Int ?? 0
        availableQuantity =  json["availableQuantity"] as? Int ?? 0
        creatAt =  json["creatAt"] as? String ?? ""
        updateAt =  json["updateAt"] as? String ?? ""
        productId =  json["productId"] as? Int ?? 0
    }
}
class ItemSize {
    var size: Int = 0
    var product: Product = Product()
}
class OrderProduct {
    var quantity: Int = 0
    var productSize: ItemSize = ItemSize()
}
class ProductCheckout {
    var product: Product = Product()
    var size: Int = 0
    var quatity: Int = 0
    func initLoad(_ json: [String: Any]) {
        product.id = json["id"] as? Int ?? 0
        product.title = json["title"] as? String ?? ""
        product.price = json["price"] as? Int ?? 0
        product.image =  json["imgURL"] as? String ?? ""
        size = json["size"] as? Int ?? 0
        quatity = json["quantity"] as? Int ?? 0
    }
}
class DataCheckOut {
    var listItem: [ProductCheckout] = []
    var address: String = ""
    var phone: String = ""
    var shipCost: Int = 0
    var totalCost: Int = 0
    func initLoad(_ json: [String: Any]) {
        if let list = json["items"] as? [[String: Any]] {
            for item in list {
                let pro: ProductCheckout = ProductCheckout()
                pro.initLoad(item)
                listItem.append(pro)
            }
        }
        if let data = json["address"] as? [String: Any] {
            address = data["fullAddress"] as? String ?? ""
            phone = data["phone"] as? String ?? ""
        }
        shipCost = json["shipmentCost"] as? Int ??  0
        totalCost = json["totalCost"] as? Int ??  0
    }
    func initLoadOrder(_ json: [String: Any]) {
        address = json["address"] as? String ?? ""
        shipCost = json["shipmentCost"] as? Int ??  0
        totalCost = json["totalCost"] as? Int ??  0
        if let list = json["orderItem"] as? [[String: Any]] {
            for item in list {
                let pro: ProductCheckout = ProductCheckout()
                pro.quatity = item["quantity"] as? Int ??  0
                if let item1 = item["ProductSize"] as? [String: Any] {
                    pro.size = item1["size"] as? Int ??  0
                    if let item2 = item1["Product"] as? [String: Any] {
                        pro.product.initLoad(item2)
                    }
                }
                listItem.append(pro)
            }
        }
    }
}
class ProductOrdered {
    var product: Product = Product()
    var datetime: String = ""
    func initLoad(_ json: [String: Any]) {
        product.initLoad(json)
        datetime = json["datetime"] as? String ?? ""
    }
}
