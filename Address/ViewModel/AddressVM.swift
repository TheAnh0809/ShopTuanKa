//
//  AddressVM.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 03/03/2022.
//

import UIKit
enum AddressUser {
    case provicen
    case distrist
    case ward
}
class AddressVM: NSObject {
    var listProvicen: [Local] = []
    var listDistrist: [Local] = []
    var listWard: [Local] = []
    var myAddress: Address = Address()
}
