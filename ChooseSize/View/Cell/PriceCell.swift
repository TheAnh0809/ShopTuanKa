//
//  PriceCell.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 14/02/2022.
//

import UIKit

class PriceCell: UITableViewCell {
    var action: (() -> Void)?
    @IBOutlet weak var btnX: UIButton!
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var lablePrice: UILabel!
    @IBOutlet weak var imagePro: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        imagePro.layer.cornerRadius = 20
        // Configure the view for the selected state
    }
    @IBAction func clickX(_ sender: Any) {
        action?()
    }
    func fillData(_ data: ProductTotal) {
        imagePro.getImageFrom(data.product.image)
        lablePrice.text = data.product.price.intToMoney()
        if data.total == 0 {
            lbNumber.text = "Hết hàng"
        } else {
            lbNumber.text = data.total.description
        }
    }
}
