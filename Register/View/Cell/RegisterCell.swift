//
//  RegisterCell.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 26/01/2022.
//

import UIKit
import SwiftUI

class RegisterCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var notifire: UILabel!
    var actionBlock: ((String) -> Void)?
    var formData: Register = .nameu
    @IBOutlet weak var textFrield: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        textFrield.delegate = self
        textFrield.layer.borderColor = UIColor.gray.cgColor
        textFrield.layer.borderWidth = 1
        notifire.isHidden = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let value = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        actionBlock?(value ?? "")
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
    @IBAction func endEdit(_ sender: Any) {
        checkData(formCell: formData)
    }
    func checkData(formCell: Register) {
        if textFrield.text?.isEmpty == true {
            showError(error: "\(formCell.rawValue) không được để trống")
        } else {
            switch formCell {
            case .nameu:
                if textFrield.text?.isEmpty == true || textFrield.text!.count > 60 {
                    showError(error: "Họ và tên sai định dạng")
                }
            case .userName:
                if textFrield.text?.searchSpacialCharater() == false {
                    showError(error: "Tên đăng nhập sai định dạng")
                }
                
            case .email:
                let string = "@gmail.com"
                if textFrield.text?.contains(string) == false {
                    showError(error: "Email sai định dạng")
                }
            case .phone:
                if textFrield.text?.isAllNumber() == false || textFrield.text?.count != 10 {
                    showError(error: "Số điện thoại sai định dạng")
                }
            case .pass:
                break
            case .againPass:
                break
            }
        }
    }
    func showError(error: String) {
        textFrield.layer.borderColor = UIColor.red.cgColor
        notifire.text = error
        notifire.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { [self] in
            setDefaut()
        }
    }
    func setDefaut() {
        notifire.isHidden = true
        textFrield.layer.borderColor = UIColor.gray.cgColor
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
