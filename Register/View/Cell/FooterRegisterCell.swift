//
//  FooterRegisterCell.swift
//  App Ban Giay
//
//  Created by Miichi on 25.02.22.
//

import UIKit

class FooterRegisterCell: UITableViewCell {
    
    @IBOutlet weak var btnDangKy: UIButton!
    @IBOutlet weak var btnDangNhap: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        btnDangKy.layer.cornerRadius = 8
    }
    
}
