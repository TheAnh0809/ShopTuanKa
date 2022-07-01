//
//  ProductProtocol.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 24/01/2022.
//

import Foundation
import UIKit
protocol ProductProtocol {
    var id: Int { get }
    var title: String { get }
    var decription: String { get }
    var image: String { get }
    var price: Int { get }
    var star: Int { get }
    var updateAt: String { get }
    var brandId: Int { get set }
}
protocol UserProtocol {
    var userName: String { get set }
    var fullName: String { get set }
    var phone: String { get set }
    var email: String { get set }
    }
struct KeyValue {
    var key: Int = 0
    var value: Any!
}
struct User: UserProtocol, Decodable {
    var fullName: String
    var userName: String
    var email: String
    var phone: String
    var pass: String
}
struct Login: Decodable {
    var userName: String
    var passWord: String
}
enum Register: String {
    case nameu = "Họ và tên"
    case userName = "Tên đăng nhập"
    case email = "Địa chỉ mail"
    case phone = "Số điện thoại"
    case pass = "Mật khẩu"
    case againPass = "Xác nhận mật khẩu"
}
class ResponErrorRegister {
    var value: String = ""
    var msg: String = ""
    var param: String = ""
    var location: String = ""
    func initLoad(_ json: [String: Any] ) {
        value =  json["value"] as? String ?? ""
        msg =  json["msg"] as? String ?? ""
        param =  json["param"] as? String ?? ""
        location =  json["location"] as? String ?? ""
    }
    
}
