//
//  User.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 14/02/2022.
//

import UIKit
class ProfileUser: UserProtocol, Decodable {
    var id: Int = 0
    var userName: String = ""
    var fullName: String = ""
    var phone: String = ""
    var email: String = ""
    var image: String = ""
    var deleteAt: String = ""
    var creatAt: String = ""
    var updateAt: String = ""
    func initLoad(_ json: [String: Any]) {
        id =  json["id"] as? Int ?? 0
        userName =  json["username"] as? String ?? ""
        fullName =  json["fullname"] as? String ?? ""
        phone =  json["phone"] as? String ?? ""
        email =  json["email"] as? String ?? ""
        image =  json["imgURL"] as? String ?? ""
        deleteAt =  json["productId"] as? String ?? ""
        creatAt =  json["creatAt"] as? String ?? ""
        updateAt =  json["updateAt"] as? String ?? ""
    }
}
