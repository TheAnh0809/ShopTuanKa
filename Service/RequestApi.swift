//
//  RequestApi.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 25/01/2022.
//

import Foundation
import SwiftUI
import Accelerate
import Alamofire

enum Method: String {
    case POST
    case GET
    case PUT
    case DELETE
}

var domain = "http://10.0.0.50:5050"
enum RequestApi {
    case login(newLogin: Login)
    case registerNew( newUser: User)
    case getProductForBrand(idBrand: Int, page: Int)
    case getBrands
    case getProduct(idPro: Int)
    case getSizeOfProduct(idPro: Int)
    case getProductForName(textSearch: String)
    case addToCart(idProductSize: Int, quatity: Int)
    case getCartOfMe
    case getProvince
    case getDistrist(idProvince: Int)
    case getWard(idDistris: Int)
    case getUser
    case getAddress
    case putAddress(address: Address)
    case checkOut(list: [Int])
    case postCheckout(list: [Int], address: String)
    case getOrdered
    case getOrderDetail(idOrder: Int)
    case changePassWord(old: String, new: String)
    case deleteOfCard(id: Int)
    case updateProductOfCart(cartId: Int, prodId: Int, quantity: Int, size: Int)
    case updateAvata(nameImg: String, dataImg: Data)
    case updateFullName(name: String)
    var method: Method {
        switch self {
        case .login, .changePassWord, .registerNew, .addToCart, .postCheckout:
            return .POST
        case .putAddress, .updateProductOfCart, .updateFullName:
            return .PUT
        case .deleteOfCard:
            return .DELETE
        default:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/api/v1/login"
        case .getProductForBrand(idBrand: _):
            return "/api/v1/products"
        case .registerNew(newUser: _):
            return "/api/v1/register"
        case .getBrands:
            return "/api/v1/brands"
        case .getProductForName:
            return "/api/v1/products"
        case .getProduct(idPro: let idPro):
            return "/api/v1/products/\(idPro)"
        case .getSizeOfProduct(idPro: let idPro):
            return "/api/v1/products/\(idPro)/sizes"
        case .addToCart:
            return "/api/v1/cart"
        case .getCartOfMe:
            return "/api/v1/cart"
        case .getProvince:
            return "/api/v1/provinces"
        case .getDistrist(idProvince: let idProvince):
            return "/api/v1/provinces/\(idProvince)/districts"
        case .getWard(idDistris: let idDistris):
            return "/api/v1/provinces/\(idDistris)/wards"
        case .getUser:
            return "/api/v1/me"
        case .getAddress:
            return "/api/v1/user/address"
        case .putAddress:
            return "/api/v1/user/address"
        case .checkOut:
            return "/api/v1/checkout"
        case .postCheckout:
            return "/api/v1/checkout"
        case .getOrdered:
            return "/api/v1/user/orders"
        case .getOrderDetail(idOrder: let idOrder):
            return "/api/v1/user/orders/\(idOrder)"
        case .changePassWord:
            return "/api/v1/user/password"
        case .deleteOfCard(id: let id):
            return "/api/v1/cart/\(id)"
        case .updateProductOfCart(cartId: let cartId, prodId: _, quantity: _, size: _):
            return "/api/v1/cart/\(cartId)"
        case .updateAvata:
            return "/api/v1/user/uploadfile"
        case .updateFullName:
            return "/api/v1/user"
        }
    }
    
    var params: [String: Any] {
        switch self {
        case .login(newLogin: let newLogin) :
            return ["username": newLogin.userName, "password": newLogin.passWord]
        case .getProductForBrand(idBrand: let brand, page: let page):
            if brand >= 0 {
                return ["brand": "\(brand)", "page": "\(page)"]
            } else {
                return ["brand": "",  "page": "\(page)"]
            }
        case .registerNew(newUser: let newUser):
            return ["username": newUser.userName, "password": newUser.pass, "fullname": newUser.fullName,
                    "phone": newUser.phone, "email": newUser.email]
        case .getProductForName(textSearch: let text):
            return ["search": text]
        case .addToCart(idProductSize: let idProductSize, quatity: let quatity):
            return ["productSizeId": "\(idProductSize)", "quantity": "\(quatity)"]
        case .getCartOfMe, .getProvince, .getDistrist, .getWard, .getUser, .getAddress,
                .getBrands, .getProduct, .getSizeOfProduct, .getOrdered, .getOrderDetail, .deleteOfCard:
            return [:]
        case .putAddress(address: let address):
            return ["provinceId": address.provinceId, "districtId": address.distristId,
                    "wardId": address.wardId, "addressDetail": address.addressDetail, "phone": address.phone]
        case .checkOut(list: let list):
            var listToString = "["
            for iteam in 0...list.count - 1 {
                listToString += "\"\(list[iteam])\""
                if iteam < list.count - 1 {
                    listToString += ","
                }
            }
            listToString += "]"
            return ["itemIDs": listToString]
        case .postCheckout(list: _, address: let address):
            return ["address": address]
        case .changePassWord(old: let old, new: let new):
            return ["password": old, "newpassword": new]
        case .updateProductOfCart(cartId: _, prodId: let prodId, quantity: let quantity, size: let size):
            return ["productId": prodId, "size": size, "quantity": quantity]
        case .updateAvata:
            return [:]
        case .updateFullName(name: let name):
            return ["fullname": name]
        }
    }
    var header: [String: String] {
        switch self {
        case .login, .registerNew:
            return ["Accept": "application/json", "Content-type": "application/json"]
        default:
            return ["Accept": "application/json",
                    "Content-type": "application/json",
                    "Authorization": "Bearer " + userDefault.string(forKey: "Token")!]
        }
    }
    func makeRequest() -> URLRequest? {
        switch self {
        case .postCheckout(list: let list, address: _):
            var components = URLComponents(string: domain)!
            components.path = path
            var listToString = "["
            for iteam in 0...list.count - 1 {
                listToString += "\(list[iteam])"
                if iteam < list.count - 1 {
                    listToString += ","
                }
            }
            listToString += "]"
            components.queryItems = [URLQueryItem(name: "idItem", value: listToString )]
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            var request = URLRequest(url: components.url!)
            for item in header {
                request.addValue(item.value, forHTTPHeaderField: item.key)
            }
            request.httpMethod = method.rawValue
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            print("----\(components.url!)")
            return request
        default:
            var components = URLComponents(string: domain)!
            components.path = path
            if self.method == .GET && self.params.isEmpty == false {
                components.queryItems = params.map { (key, value) in
                    URLQueryItem(name: key, value: value as? String)
                }
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            var request = URLRequest(url: components.url!)
            for item in header {
                request.addValue(item.value, forHTTPHeaderField: item.key)
            }
            request.httpMethod = method.rawValue
            if self.method == .POST || self.method == .PUT {
                request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                print(params)
            }
            print("----\(components.url!)")
            return request
        }
    }
}
