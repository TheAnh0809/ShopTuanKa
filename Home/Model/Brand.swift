//
//  Brand.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 17/02/2022.
//

import UIKit
class Brand {
    var id: Int = 0
    var name: String = ""
    var image: String = ""
    var creatAt: String = ""
    var updateAt: String = ""
    func initLoad(_ json: [String: Any]) {
        id =  json["id"] as? Int ?? 0
        name =  json["name"] as? String ?? ""
        image =  json["imgURL"] as? String ?? ""
        creatAt =  json["createdAt"] as? String ?? ""
        updateAt =  json["updatedAt"] as? String ?? ""
    }
}
