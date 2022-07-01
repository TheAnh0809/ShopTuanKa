//
//  InforCell.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 20/02/2022.
//

import UIKit

class InforCell: UITableViewCell {
    var actionEdit: (() -> Void)?
    var actionChangePass: (() -> Void)?
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickEditProfile(_ sender: Any) {
        actionEdit?()
    }
    @IBAction func clickChangePass(_ sender: Any) {
        actionChangePass?()
    }
    func fillData(_ data: ProfileUser) {
        lbName.text = data.fullName
        lbEmail.text = data.email
    }
}
