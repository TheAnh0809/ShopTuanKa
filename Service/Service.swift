//
//  Service.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 24/01/2022.
import UIKit
import Foundation
import Alamofire

enum RequestError: Error, LocalizedError {
    case dataFalse(err: String)
    case expireToken
    var errorDescription: String? {
        switch self {
        case .dataFalse(err: let error):
            return error
        case .expireToken:
            return "Đăng nhập lại"
        }
    }
}

struct Profile: Codable {
    var name: String
}
class ServiceAPI: NSObject {
    static let share: ServiceAPI = ServiceAPI()
    private override init() {}
    
    let urlSession = URLSession.shared
    
    private func request(request: RequestApi, callback: @escaping ([String: Any]?, Error?) -> Void) {
        guard let request = request.makeRequest() else {
            return
        }
        let dataTask = urlSession.dataTask(with: request) { data, _, error in
            guard error == nil else {
                callback(nil, error)
                return
            }
            guard let data = data else {
                callback(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    callback(nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
                    return
                }
                callback(json, nil)
            } catch let error {
                print(error.localizedDescription)
                callback(nil, error)
            }
        }
        dataTask.resume()
    }
    
    func getProduct(idBrand: Int, page: Int, closure: @escaping (_ response: [Product]?, _ error: RequestError?) -> Void) {
        var list: [Product] = []
        request(request: .getProductForBrand(idBrand: idBrand, page: page)) {response, _ in
            if let data = response?["data"]  as? [String: Any] {
                if let data1 = data["products"] as? [[String: Any]] {
                    for item in data1 {
                        let product = Product()
                        product.initLoad(item)
                        list.append(product)
                    }
                    closure(list, nil)
                }
            }
            if (response?["errors"] as? [String: Any]) != nil {
                closure(nil, .expireToken)
            }
        }
    }
    func getRegister(newUser: User, closure: @escaping (_ response: Bool, _ error: String) -> Void ) {
        var okRegister = false
        var messDialog = ""
        request(request: .registerNew(newUser: newUser)) { response, error in
            if let data = response {
                if let data1 = data["errors"] as? [[String: Any]] {
                    okRegister = false
                    for item in data1 {
                        if let data2 = item["errors"] as? [[String: Any]] {
                            for item1 in data2 {
                                let error: ResponErrorRegister = ResponErrorRegister()
                                error.initLoad(item1)
                                messDialog = error.msg.changeErrorToVN()
                                break
                            }
                        }
                    }
                } else {
                    if let data1 = data["data"] as? [String: Any] {
                        okRegister = true
                        if let token = data1["token"] {
                            userDefault.set("\(token)", forKey: "Token")
                        }
                        if let user = data1["user"] {
                            print("+\(user)")
                        }
                        
                    } else {
                        closure(false, "Kiểm tra đường truyền mạng")
                    }
                }
                closure(okRegister, messDialog)
            }
        }
    }
    func checkLogin(newLogin: Login, closure: @escaping (_ response: Bool, _ error: String) -> Void) {
        var checkLogin = false
        var messDialog = ""
        request(request: .login(newLogin: newLogin)) { response, error  in
            if let data = response {
                if let data1 = data["data"]  as? [String: Any] {
                    checkLogin = true
                    if let token = data1["token"] as? String {
                        UserDefaults.standard.set(token, forKey: "Token")
                    }
                    if let user = data1["user"] {
                        print("+\(user)")
                    }
                } else {
                    if let data1 = data["errors"] as? [[String: Any]] {
                        checkLogin = false
                        for item in data1 {
                            if let data3 = item["msg"] as? String {messDialog = data3}
                            if let data2 = item["errors"] as? [[String: Any]] {
                                for item1 in data2 {
                                    let error: ResponErrorRegister = ResponErrorRegister()
                                    error.initLoad(item1)
                                    messDialog = error.msg.changeErrorToVN()
                                    break
                                }
                            }
                        }
                    }
                }
                closure(checkLogin, messDialog)
            }
            if error != nil {
                closure(false, "Kiểm tra đường truyền mạng")
            }
        }
    }
    func getBrands(closure: @escaping (_ response: [Brand]?, _ error: RequestError?) -> Void) {
        var list: [Brand] = []
        request(request: .getBrands) {response, error in
            if let data = response?["data"]  as? [[String: Any]] {
                for item in data {
                    let brand: Brand = Brand()
                    brand.initLoad(item)
                    list.append(brand)
                }
                closure(list, nil)
            } else {
                closure(nil, .dataFalse(err: "Lỗi kết nối"))
            }
            if error != nil {
                closure(nil, .expireToken)
            }
        }
    }
    func getProductSearchName(text: String, closure: @escaping (_ response: [Product]?, _ error: RequestError?) -> Void) {
        var list: [Product] = []
        request(request: .getProductForName(textSearch: text)) {response, error in
            if let data = response?["data"]  as? [String: Any] {
                if let data1 = data["products"] as? [[String: Any]] {
                    for item in data1 {
                        let product = Product()
                        product.initLoad(item)
                        list.append(product)
                    }
                    closure(list, nil)
                }
            }
            if error != nil {
                closure(nil, .expireToken)
            }
        }
    }
    func getProductForId(idPro: Int, closure: @escaping (_ response: ProductTotal?, _ error: RequestError?) -> Void) {
        let product: ProductTotal = ProductTotal()
        request(request: .getProduct(idPro: idPro)) {response, _ in
            if let data = response?["data"]  as? [String: Any] {
                product.initLoad(data)
                closure(product, nil)
            } else {
                closure(nil, .expireToken)
            }
        }
    }
    func getSizeOfProduct(idPro: Int, closure: @escaping (_ response: [ProductSize]?, _ error: Error?) -> Void) {
        var list: [ProductSize] = []
        request(request: .getSizeOfProduct(idPro: idPro)) {response, _ in
            if let data = response?["data"]  as? [[String: Any]] {
                for item in data {
                    let size: ProductSize = ProductSize()
                    size.initLoad(item)
                    list.append(size)
                }
            }
            closure(list, nil)
        }
    }
    func postProductToCart(idProducSize: Int, quatity: Int,
                           closure: @escaping (_ response: Any?, _ error: RequestError?) -> Void ) {
       request(request: .addToCart(idProductSize: idProducSize, quatity: quatity)) { respons, _ in
            if (respons?["data"] as? [String: Any]) != nil {
                closure(true, nil)
            } else {
                if let data = respons?["errors"] as? [[String: Any]] {
                    for item in data {
                        if let mess = item["msg"] as? String {
                            if mess == "UNAUTHORIZED" {
                                closure(nil, .expireToken)
                            } else {
                                closure(nil, .dataFalse(err: "Thao tác lỗi"))
                            }
                        }
                    }
                }
            }
        }
    }
    func getCartOfMe(closure: @escaping (_ response: [ItemOfCart]?, _ error: RequestError?) -> Void ) {
        var list: [ItemOfCart] = []
        request(request: .getCartOfMe) {response, _ in
            if let data = response?["data"]  as? [[String: Any]] {
                for item in data {
                    let itemCart: ItemOfCart = ItemOfCart()
                    itemCart.initLoad(item)
                    list.append(itemCart)
                }
                closure(list, nil)
            }
            if (response?["errors"] as? [String: Any]) != nil {
                closure(nil, .expireToken)
            }
            
        }
    }
    func getProvince( closure: @escaping (_ response: [Local]?, _ error: RequestError?) -> Void) {
        var list: [Local] = []
        request(request: .getProvince) {response, error in
            if let data = response?["data"]  as? [[String: Any]] {
                for item in data {
                    let local = Local()
                    local.initLoad(item)
                    list.append(local)
                }
                closure(list, nil)
            } else {
                closure(nil, .expireToken)
            }
            if error != nil {
                closure(nil, .dataFalse(err: "Kiểm tra đường truyền"))
            }
        }
    }
    func getDistrist(idProvicen: Int, closure: @escaping (_ response: [Local]?, _ error: RequestError?) -> Void) {
        var list: [Local] = []
       request(request: .getDistrist(idProvince: idProvicen)) {response, error in
            if let data = response?["data"]  as? [[String: Any]] {
                for item in data {
                    let local = Local()
                    local.initLoad(item)
                    list.append(local)
                }
                closure(list, nil)
            } else {
                closure(nil, .expireToken)
            }
            if error != nil {
                closure(nil, .dataFalse(err: "Kiểm tra đường truyền"))
            }
        }
    }
    func getWard(idDistrict: Int, closure: @escaping (_ response: [Local]?, _ error: RequestError?) -> Void) {
        var list: [Local] = []
        request(request: .getWard(idDistris: idDistrict)) {response, error in
            if let data = response?["data"]  as? [[String: Any]] {
                for item in data {
                    let local = Local()
                    local.initLoad(item)
                    list.append(local)
                }
                closure(list, nil)
            } else {
                closure(nil, .expireToken)
            }
            if error != nil {
                closure(nil, .dataFalse(err: "Kiểm tra đường truyền"))
            }
        }
    }
    
}

extension ServiceAPI {
    func getUser(closure: @escaping (_ response: ProfileUser?, _ error: RequestError?) -> Void) {
        let profile: ProfileUser = ProfileUser()
        request(request: .getUser) { respone, error in
            if let data = respone?["data"] as? [String: Any] {
                profile.initLoad(data)
                closure(profile, nil)
            } else {
                closure(nil, .expireToken)
            }
            if error != nil {
                closure(nil, .dataFalse(err: "Lỗi kết nối"))
            }
        }
    }
    func getAddress(closure: @escaping (_ response: Address?, _ error: RequestError?) -> Void) {
        let address: Address = Address()
        var err: String = ""
        request(request: .getAddress) { respone, error in
            if let data = respone?["data"] as? [String: Any] {
                address.initLoad(data)
                closure(address, nil)
            }
            if let data = respone?["errors"] as? [[String: Any]] {
                err = (data[0]["msg"] as? String)!
                if err == "UNAUTHORIZED" {
                    closure(nil, .expireToken)
                } else {
                    closure(nil, .dataFalse(err: "Chưa đăng ký địa chỉ"))
                }
            }
            if error != nil {
                closure(nil, .dataFalse(err: "Lỗi kết nối"))
            }
        }
    }
    func checkLoiAddress(param: String) -> String {
        switch param {
        case "provinceId":
            return "Chọn lại Tỉnh/Thành phố"
        case "districtId":
            return "Chọn lại Quận/Huyện"
        case "wardId":
            return "Chọn lại Xã/Phường"
        case "addressDetail":
            return "Thêm địa chỉ cụ thể"
        default:
            return "Số điện thoại sai"
        }
    }
    func putAddress(address: Address, closure: @escaping (_ response: Bool?, _ error: String?) -> Void) {
        var okMsg = false
       request(request: .putAddress(address: address)) { respone, error in
            if (respone?["data"] as? [String: Any]) != nil {
                okMsg = true
                closure(okMsg, nil)
            }
            if let data = respone?["errors"] as? [[String: Any]] {
                for item in data {
                    if let data2 = item["param"] as? String {
                        closure(nil, self.checkLoiAddress(param: data2))
                        break
                    }
                }
            }
            if error != nil {
                closure(nil, "Lỗi kết nối")
            }
        }
    }
    func checkOut(list: [Int], closure: @escaping (_ response: DataCheckOut?, _ error: RequestError?) -> Void) {
        request(request: .checkOut(list: list)) { respone, error in
            if let dataA = respone?["data"] as? [String: Any] {
                let dataCheck: DataCheckOut = DataCheckOut()
                dataCheck.initLoad(dataA)
                closure(dataCheck, nil)
            }
            if let data = respone?["errors"] as? [[String: Any]] {
                for item in data {
                    if item["msg"] != nil {
                        closure(nil, .expireToken)
                    }
                    closure(nil, .dataFalse(err: "Sai dữ liệu check out"))
                }
            }
            if error != nil {
                closure(nil, .dataFalse(err: "Lỗi kết nối"))
            }
        }
    }
    func postCheckOutProduct(list: [Int], address: String, closure: @escaping (_ response: Bool?,
                                                                               _ error: RequestError?) -> Void) {
       request(request: .postCheckout(list: list, address: address)) { respone, error in
            if (respone?["data"] as? [String: Any]) != nil {
                closure(true, nil)
            }
            if let data = respone?["errors"] as? [[String: Any]] {
                for item in data {
                    if let err = item["param"]  as? String {
                        closure(nil, .dataFalse(err: err))
                    }
                    if let err = item["msg"]  as? String {
                        if err == "BAD REQUEST" {
                            closure(nil, .dataFalse(err: "Lỗi thao tác"))
                        }
                        closure(nil, .expireToken)
                    }
                }
            }
            if error != nil {
                closure(nil, .dataFalse(err: "Lỗi kết nối"))
            }
        }
    }
    func getOrdered(closure: @escaping (_ response: [ProductOrdered]?, _ error: RequestError?) -> Void) {
        var list: [ProductOrdered] = []
        request(request: .getOrdered) { respone, error in
            if let respone = respone {
                if let data = respone["data"] as? [String: Any] {
                    if let data1 = data["list"] as? [[String: Any]] {
                        for item in data1 {
                            let product: ProductOrdered = ProductOrdered()
                            product.initLoad(item)
                            list.append(product)
                        }
                    }
                    closure(list, nil)
                }
            } else {
                closure(nil, .expireToken)
            }
            if error != nil {
                closure(nil, .dataFalse(err: "Lỗi kết nối"))
            }
        }
    }
    func deleteFromCard(id: Int, closure: @escaping (_ response: Bool?, _ error: RequestError?) -> Void) {
        request(request: .deleteOfCard(id: id)) { respone, error in
            if (respone?["data"] as? [String: Any]) != nil {
                closure(true, nil)
            }
            if let err = respone?["errors"] as? [[String: Any]] {
                for item in err {
                    if let iteam2 = item["msg"] as? String {
                        if iteam2 == "BAD REQUEST" {
                            closure(nil, .dataFalse(err: "Sản phẩm trong giỏ hàng bị lỗi"))
                        } else {
                            closure(nil, .expireToken)
                        }
                    }
                }
            }
            if error != nil {
                closure(nil, .dataFalse(err: "Lỗi kết nối"))
            }
        }
    }
    func getDetailOrdered(id: Int, closure: @escaping (_ response: DataCheckOut?, _ error: RequestError?) -> Void) {
        request(request: .getOrderDetail(idOrder: id)) { respone, error in
            if let dataA = respone?["data"] as? [String: Any] {
                let dataCheck: DataCheckOut = DataCheckOut()
                dataCheck.initLoadOrder(dataA)
                closure(dataCheck, nil)
            }
            if let data = respone?["errors"] as? [[String: Any]] {
                for item in data {
                    if item["msg"] != nil {
                        closure(nil, .expireToken)
                    }
                    closure(nil, .dataFalse(err: "Sai dữ liệu"))
                }
            }
            if error != nil {
                closure(nil, .dataFalse(err: "Lỗi kết nối"))
            }
        }
    }
    func changePassWord(old: String, new: String, closure: @escaping (_ response: Bool?, _ error: RequestError?) -> Void) {
        request(request: .changePassWord(old: old, new: new)) { respone, _ in
            if let respone = respone {
                if let err = respone["errors"] as? [[String: Any]] {
                    for item in err {
                        if let param = item["param"] as? String {
                            if param == "password" {
                                closure(nil, .dataFalse(err: "Mật khẩu cũ sai"))
                            }
                            if param == "newpassword" {
                                closure(nil, .dataFalse(err:
                                                            "Mật khẩu mới (6-12) cần có chữ hoa, chữ thường, số và một ký tự đặc biệt"))
                            }
                        } else {
                            if let msg = item["msg"] as? String {
                                if msg == "DATA INVALID" {
                                    closure(nil, .dataFalse(err: "Mật khẩu cũ sai"))
                                }
                            } else {
                                closure(nil, .expireToken)
                            }
                        }
                    }
                }
                if (respone["data"] as? [String: Any]) != nil {
                    closure(true, nil)
                }
            }
        }
    }
    func updateProductInCard(idCard: Int, idProd: Int, size: Int, quantity: Int,
                             closure: @escaping (_ response: Bool?, _ error: RequestError?) -> Void) {
        request(request: .updateProductOfCart(cartId: idCard,
                                                               prodId: idProd, quantity: quantity,
                                                               size: size)) { respone, error in
            if let respone = respone {
                if let data = respone["data"] as? [String: Any] {
                    if data.isEmpty == false {
                        closure(true, nil)
                    }
                }
                if let err = respone["errors"] as? [[String: Any]] {
                    for item in err {
                        if let iteam2 = item["msg"] as? String {
                            if iteam2 == "BAD REQUEST" {
                                closure(nil, .dataFalse(err: "Sản phẩm trong giỏ hàng bị lỗi"))
                            } else {
                                closure(nil, .expireToken)
                            }
                        }
                    }
                }
            }
            if error != nil {
                closure(nil, .dataFalse(err: "Lỗi kết nối"))
            }
        }
    }
    func updateFullName(name: String, closure: @escaping (_ response: Bool?, _ error: RequestError?) -> Void) {
        request(request: .updateFullName(name: name)) { respone, error in
            if let respone = respone {
                if let data = respone["data"] as? [String: Any] {
                    if data.isEmpty == false {
                        closure(true, nil)
                    }
                }
                if let err = respone["errors"] as? [[String: Any]] {
                    for item in err {
                        if let iteam2 = item["msg"] as? String {
                            if iteam2 == "BAD REQUEST" {
                                closure(nil, .dataFalse(err: "Thao tác lỗi"))
                            } else {
                                closure(nil, .expireToken)
                            }
                        }
                    }
                }
            }
            if error != nil {
                closure(nil, .dataFalse(err: "Lỗi kết nối"))
            }
        }
    }
    func uploadAvata(image: UIImage, closure: @escaping (_ response: Bool?, _ error: RequestError?) -> Void) {
        var components = URLComponents(string: domain)!
        components.path = "/api/v1/user/uploadfile"
        var request = URLRequest(url: components.url!)
        ["Accept": "application/json",
                "Content-type": "application/json",
         "Authorization": "Bearer " + userDefault.string(forKey: "Token")!].forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod = "POST"
        let jpegData = image.jpegData(compressionQuality: 1)
        _ = AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(jpegData!, withName: "file", fileName: "somename.png", mimeType: "image/jpeg")
        }, with: request ).response { data in
        let data = try? JSONSerialization.jsonObject(with: data.data!, options: []) as? [String: Any]
            print(data)
            if let _ = data?["data"] as? [String: Any] {
                closure(true, nil)
            } else {
                closure(nil, .dataFalse(err: "Chưa thể upload ảnh của bạn"))
            }
        }
    }
}

func tokendated() {
    userDefault.set("", forKey: "Token")
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let welcome = storyboard.instantiateInitialViewController()
    UIApplication.shared.keyWindow?.rootViewController = welcome
}
