//
//  Address.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 14/02/2022.
//

import UIKit
class Address {
    var id: Int = 0
    var userId: Int = 0
    var provinceId: Int = 0
    var province: String = ""
    var distristId: Int = 0
    var distrist: String = ""
    var wardId: Int = 0
    var ward: String = ""
    var addressDetail: String = ""
    var phone: String = ""
    var creatAt: String = ""
    var updateAt: String = ""
    func checkData() -> Bool {
        if provinceId == 0 {
            return false
        }
        if distristId == 0 {
            return false
        }
        if wardId == 0 {
            return false
        }
        if addressDetail.isEmpty == true {
            return false
        }
        if phone.isEmpty == true {
            return false
        }
        return true
    }
    func initLoad(_ json: [String: Any]) {
        id =  json["id"] as? Int ?? 0
        userId =  json["userId"] as? Int ?? 0
        wardId =  json["WardID"] as? Int ?? 0
        ward =  json["ward"] as? String ?? ""
        provinceId =  json["ProvinceID"] as? Int ?? 0
        province =  json["province"] as? String ?? ""
        distristId =  json["DistrictID"] as? Int ?? 0
        distrist =  json["district"] as? String ?? ""
        addressDetail =  json["addressDetail"] as? String ?? ""
        phone =  json["phone"] as? String ?? ""
        creatAt =  json["createdAt"] as? String ?? ""
        updateAt =  json["updatedAt"] as? String ?? ""
    }
}
