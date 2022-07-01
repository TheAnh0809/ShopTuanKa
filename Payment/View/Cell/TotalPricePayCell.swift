//
//  TotalPricePayCell.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 22/02/2022.
//

import UIKit

class TotalPricePayCell: UITableViewCell {
    var callBack: (() -> Void)?
    @IBOutlet weak var lbTotalCost: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbShipCost: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func clickAddress(_ sender: Any) {
        callBack?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func fillData(_ data: DataCheckOut) {
        if data.address.isEmpty == true {
            lbAddress.text = "Đăng ký địa chỉ"
        } else {
            lbAddress.text = data.address
        }
        lbShipCost.text = data.shipCost.intToMoney()
        lbTotalCost.text = data.totalCost.intToMoney()
    }
}
