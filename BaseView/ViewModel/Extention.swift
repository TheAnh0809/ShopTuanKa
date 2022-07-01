//
//  Extention.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 26/01/2022.
//

import Foundation
import UIKit
import Kingfisher
let baseColor = UIColor(red: 191/255, green: 19/255, blue: 18/255, alpha: 1)
extension Int {
    func intToMoney() -> String {
        var number = self
        var money: String = " đ"
        while number > 1000 {
            let numX = number % 1000
            if numX == 0 {money = ".000"  + money}
            if numX > 0 && numX < 10 {money = ".00" + numX.description + money}
            if numX > 0 && numX < 100 {money = ".0" + numX.description + money}
            if numX >= 100 {money = "." + numX.description + money}
            number /= 1000
        }
        money = number.description + money
        return money
    }
}
extension UIImageView {
    func toCircle() {
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.masksToBounds = true
    }
    func getImageFrom(_ link: String) {
        let url = URL(string: domain +  link)
        let processor = DownsamplingImageProcessor(size: self.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 20)
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "a"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
}
public func checkInforRegister(info: [String]) -> Int {
    if info[0].description.containsSpecialCharacter == true {
        return 0
    } else {
        return 1
    }
}
extension UITextFieldDelegate {
    
}
extension UIViewController {

    func showTextChangeName(oldName: String) {
        let alert = UIAlertController(title: "Thay đổi thông tin",
                                      message: "Thay đổi tên của bạn", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = oldName
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [alert] (_) in
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
            let newName = alert?.textFields![0].text
            if newName!.count > 60 || newName?.isEmpty == true {
                self.showDiglog(title: "Lỗi", messenger: "Tên của bạn có độ dài từ 0 ~ 6 kí tự!", button: "Ok")
            } else {
                ServiceAPI.share.updateFullName(name: newName!) { response, error in
                    DispatchQueue.main.async {
                        if response != nil {
                            self.showDiglog(title: "Thành công",
                                            messenger: "Thay đổi tên thành công", button: "Ok") {
                                if let self = self as? InforViewController {
                                    self.user.fullName = newName!
                                    self.tbvShow.reloadData()
                                }
                            }
                        }
                        if let error = error {
                            self.showDiglog(title: "Lỗi", messenger: error.localizedDescription, button: "Ok")
                        }
                    }
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func showTextLogChangePass(title: String, mess: String) {
        let alert = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.setDefautText(text: "Mật khẩu cũ", color: .lightGray, corner: 15)
            textField.isSecureTextEntry = true
        }
        alert.addTextField { (textField) in
            textField.setDefautText(text: "Mật khẩu mới", color: .lightGray, corner: 15)
            textField.isSecureTextEntry = true
        }
        alert.addTextField { (textField) in
            textField.setDefautText(text: "Nhập lại mật khẩu mới", color: .lightGray, corner: 15)
            textField.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [alert] (_) in
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
            let oldpass = alert?.textFields![0].text
            let newpass = alert?.textFields![1].text
            let agianpass = alert?.textFields![2].text
            if newpass != agianpass {
                self.showDiglog(title: "Lỗi", messenger: "Mật khẩu mới không trùng khớp", button: "Ok")
            } else {
                ServiceAPI.share.changePassWord(old: oldpass!, new: newpass!) { response, error in
                    DispatchQueue.main.async {
                        if response != nil {
                            self.showDiglog(title: "Thành công",
                                            messenger: "Thay đổi mật khẩu thành công", button: "Ok")
                        }
                        if let error = error {
                            self.showDiglog(title: "Lỗi", messenger: error.localizedDescription, button: "Ok")
                        }
                    }
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    func pushView<T: UIViewController>(storybard: UIStoryboard, nextView: T.Type, callback: ((T) -> Void)? = nil) {
        let secondView = storybard.instantiateViewController(withIdentifier: T.nameClass) as? T
        callback?(secondView!)
        self.navigationController?.pushViewController(secondView!, animated: true)
        
    }
    func present<T: UIViewController>(storybard: UIStoryboard? = nil, nextView: T.Type, callback: ((T)
                                                                                                   -> Void)? = nil) {
        let storybard = storybard == nil ? self.storyboard : storybard
        guard let next = storybard?.instantiateViewController(withIdentifier: T.nameClass) as? T else {
            return
        }
        callback?(next)
        next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true, completion: nil)
    }
    func showDiglog(title: String, messenger: String, button: String, action: (() -> Void)? = nil) {
        let alertController =
        UIAlertController(title: title, message: messenger, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: button, style: .default, handler: {(_) -> Void in
            action?()
        })
        alertController.addAction(button)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
}

extension NSObject {
    public class var nameClass: String {
        return String(describing: self)
    }
}
extension UITableView {
    func registerListCell(list: [UITableViewCell.Type]) {
        for item in list {
            self.register(UINib(nibName: String(describing: item), bundle: nil),
                          forCellReuseIdentifier: String(describing: item))
        }
    }
}
extension UITextField {
    func setDefautText(text: String, color: UIColor, corner: Int? = nil) {
        if corner != nil {
            self.layer.cornerRadius = CGFloat(corner ?? 5)
        } else {
            self.layer.cornerRadius = CGFloat(corner ?? 5)
        }
        self.attributedPlaceholder =
        NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}
extension String {
    var containsSpecialCharacter: Bool {
        let regex = ".*[^A-Za-z0-9].*"
        let testString = NSPredicate(format: "SELF MATCHES %@", regex)
        return testString.evaluate(with: self)
    }
}
extension UICollectionView {
    func registerTableViewCell(_ nameCell: String, _ with: Double? = nil,
                               _ hight: Double? = nil, _ kind: ScrollDirection,
                               config: ((UICollectionViewFlowLayout) -> Void)? = nil) {
        self.register(UINib(nibName: nameCell, bundle: nil), forCellWithReuseIdentifier: nameCell)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = kind
        if with != nil && hight != nil {
            layout.itemSize = CGSize(width: with!, height: hight!)
        }
        config?(layout)
        self.collectionViewLayout = layout
    }
}
extension String {
    func changeDetal() -> String {
        var newString = self
        newString.remove(at: self.startIndex)
        newString = newString.replacingOccurrences(of: "\n", with: "")
        newString = newString.replacingOccurrences(of: "  ", with: "")
        newString = newString.replacingOccurrences(of: "-", with: "\n", options: .literal, range: nil)
        return newString
    }
    func changeErrorToVN() -> String {
        switch self {
        case "Fullname is invalid":
            return "Họ và tên không hợp lệ (1-60)."
        case "Username only contains 5-30 characters including: letters(a-z, A-Z), numbers(0-9), (.) and (_)":
            return "Tài khoản đăng nhập (5-30), có thể có chữ hoa, chữ thường, số và ký tự (. _)."
        case "Password contains 6-12 characters including : at least 1 UPPERCASE (A-Z), 1 lowercase (a-z), 1 number (0-9), 1 special character(!@#$%^&*)":
            return "Mật khẩu (6-12) phải bảo gồm ít nhất 1 chữ hoa, 1 chữ thường, 1 số, 1 ký tự đặc biệt (!@#$%^&*)."
        case "Email must be valid, contains 17-45 characters, @gmail.com only":
            return "Email dài từ 17-45 ký tự, phải có @gmail.com"
        case "Phone is invalid":
            return "Số điện thoại không khả dụng."
        case "Username has been already in use":
            return "Tài khoản đăng nhập đã được người khác dùng."
        case "Email has been already in use":
            return "Email đã được người khác dùng."
        case "Phone has been already in use":
            return "Số điện thoại đã được người khác dùng."
        case "Password is invalid":
            return "Tên đăng nhập hoặc tài khoản không chính xác."
        case "Username is invalid":
            return "Tên đăng nhập hoặc tài khoản không chính xác."
        case "BAD REQUEST":
            return "Tên đăng nhập hoặc tài khoản không chính xác."
        default:
            return "Lỗi thông tin đăng ký!"
        }
    }
    func searchSpacialCharater() -> Bool {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890._")
        if self != self.filter({okayChars.contains($0) }) {
            return false
        }
        return true
    }
    func isAllNumber() -> Bool {
        let okayChars = Set("0123456789")
        if self != self.filter({okayChars.contains($0) }) {
            return false
        }
        return true
    }
    func subScript(characterIndex: Int) -> Self {
        return String(self[index(startIndex, offsetBy: characterIndex)])
    }
    func getDateOfTime() -> String {
        var result = ""
        var range = self.index(self.startIndex, offsetBy: 8)...self.index(self.startIndex, offsetBy: 9)
        result += String(self[range]) + "/"
        range = self.index(self.startIndex, offsetBy: 5)...self.index(self.startIndex, offsetBy: 6)
        result += String(self[range]) + "/"
        range = self.index(self.startIndex, offsetBy: 0)...self.index(self.startIndex, offsetBy: 3)
        result += String(self[range])
        return  result
    }
}
func showDialogAtBaseView(title: String, messenger: String, button: String, action: (() -> Void)? = nil) {
    let alertController =
    UIAlertController(title: title, message: messenger, preferredStyle: UIAlertController.Style.alert)
    let button = UIAlertAction(title: button, style: .default, handler: {(_) -> Void in
        action?()
    })
    alertController.addAction(button)
    let rootVC = UIApplication.shared.keyWindow?.rootViewController
    rootVC?.present(alertController, animated: true)
}
