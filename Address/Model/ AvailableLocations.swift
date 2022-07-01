//
//   AvailableLocations.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 19/02/2022.
//

import UIKit
class Local {
    var name: String = ""
    var code: Int = 0
    var divisiontype: String = ""
    var codename: String = ""
    var phonecode: Int = 0
    func initLoad(_ json: [String: Any]) {
        name =  json["name"] as? String ?? ""
        code =  json["code"] as? Int ?? 0
        divisiontype =  json["division_type"] as? String ?? ""
        codename =  json["codename"] as? String ?? ""
        phonecode =  json["phone_code"] as? Int ?? 0
    }
}
