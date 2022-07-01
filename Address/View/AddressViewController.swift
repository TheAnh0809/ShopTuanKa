//
//  AddressViewController.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 08/02/2022.
//

import UIKit
import iOSDropDown
import SwiftUI

class AddressViewController: BaseViewController {
    var addressVM: AddressVM = AddressVM()
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var textZip: UITextField!
    @IBOutlet weak var textDetail: UITextField!
    @IBOutlet weak var textNumber: UITextField!
    @IBOutlet weak var textTp: DropDown!
    @IBOutlet weak var textHuyen: DropDown!
    @IBOutlet weak var textXa: DropDown!
    var tabAddress: AddressUser = .provicen
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Địa chỉ nhận hàng"
        setBorder(list: [textTp.self, textHuyen.self, textXa.self, textZip.self, textDetail.self, textNumber.self])
        btnOk.layer.cornerRadius = 15
        setDefautAddress()
        getListProvice()
        setActionOfTextField()
    }
    func setBorder(list: [UITextField]) {
        for item in list {
            item.layer.borderColor = UIColor.gray.cgColor
            item.layer.borderWidth = 1
            item.layer.cornerRadius = 5
        }
    }
    func setActionOfTextField() {
        textTp.didSelect {(selectedText, index, _) in
            self.addressVM.myAddress.province = selectedText
            self.addressVM.myAddress.provinceId = self.addressVM.listProvicen[index].code
            self.getListDistric(idPro: self.addressVM.myAddress.provinceId)
            self.addressVM.myAddress.distristId = 0
            self.addressVM.myAddress.distrist = ""
            self.textHuyen.text = ""
            self.addressVM.myAddress.wardId = 0
            self.addressVM.myAddress.ward = ""
            self.textXa.text = ""
        }
        textHuyen.didSelect { selectedText, index, _ in
            self.addressVM.myAddress.distrist = selectedText
            self.addressVM.myAddress.distristId = self.addressVM.listDistrist[index].code
            self.getListWard(idDis: self.addressVM.myAddress.distristId)
            self.addressVM.myAddress.wardId = 0
            self.addressVM.myAddress.ward = ""
            self.textXa.text = ""
        }
        textXa.didSelect { selectedText, index, _ in
            self.addressVM.myAddress.ward = selectedText
            self.addressVM.myAddress.wardId = self.addressVM.listWard[index].code
            
        }
    }
    func setDefautAddress() {
        ServiceAPI.share.getAddress { response, error in
            DispatchQueue.main.async {
                if let response = response {
                    self.addressVM.myAddress = response
                    self.textXa.text = self.addressVM.myAddress.ward
                    self.textHuyen.text = self.addressVM.myAddress.distrist
                    self.textTp.text = self.addressVM.myAddress.province
                    self.textDetail.text = self.addressVM.myAddress.addressDetail
                    self.textNumber.text = self.addressVM.myAddress.phone
                    self.getListDistric(idPro: self.addressVM.myAddress.provinceId)
                    self.getListWard(idDis: self.addressVM.myAddress.distristId)
                }
                if let error = error {
                    switch error {
                    case .dataFalse:
                        return
                    case .expireToken:
                        self.showDiglog(title: "Lỗi", messenger: error.errorDescription!, button: "Ok") {
                            tokendated()
                        }
                    }
                }
            }
        }
    }
    func getListProvice() {
        ServiceAPI.share.getProvince { list, error in
            DispatchQueue.main.async {
                if let list = list {
                    self.addressVM.listProvicen = list
                    var listData: [String] = []
                    for item in self.addressVM.listProvicen {
                        listData.append(item.name)
                    }
                    self.textTp.optionArray = listData
                }
                if let error = error {
                    self.showDiglog(title: "Lỗi", messenger: error.errorDescription!, button: "Ok")
                }
            }
        }
    }
    func getListDistric(idPro: Int) {
        ServiceAPI.share.getDistrist(idProvicen: idPro) { response, error in
            DispatchQueue.main.async {
                if let list = response {
                    self.addressVM.listDistrist = list
                    var listData: [String] = []
                    for item in self.addressVM.listDistrist {
                        listData.append(item.name)
                    }
                    self.textHuyen.optionArray = listData
                }
                if let error = error {
                    switch error {
                    case .dataFalse:
                        self.showDiglog(title: "Lỗi", messenger: error.errorDescription!, button: "Ok")
                    case .expireToken:
                        self.showDiglog(title: "Lỗi", messenger: error.errorDescription!, button: "Ok") {
                            tokendated()
                        }
                    }
                }
            }
        }
    }
    func getListWard(idDis: Int) {
        ServiceAPI.share.getWard(idDistrict: idDis) { response, error in
            DispatchQueue.main.async {
                if let list = response {
                    self.addressVM.listWard = list
                    var listData: [String] = []
                    for item in self.addressVM.listWard {
                        listData.append(item.name)
                    }
                    self.textXa.optionArray = listData
                }
                if let error = error {
                    self.showDiglog(title: "Lỗi", messenger: error.errorDescription!, button: "Ok")
                }
            }
        }
    }
    @IBAction func clickOk(_ sender: Any) {
        addressVM.myAddress.addressDetail = textDetail.text!
        addressVM.myAddress.phone = textNumber.text!
        if addressVM.myAddress.checkData() == false {
            showDiglog(title: "Lỗi", messenger: "Điền đầy đủ thông tin", button: "Ok")
        } else {
            ServiceAPI.share.putAddress(address: addressVM.myAddress) { response, error in
                DispatchQueue.main.async {
                    if response != nil {
                        self.navigationController?.popViewController(animated: true)
                    }
                    if let error = error {
                        self.showDiglog(title: "Lỗi", messenger: error, button: "Ok")
                    }
                }
            }
            
        }
        
    }
}
