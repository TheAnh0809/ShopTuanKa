//
//  PayCell.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 22/02/2022.
//

import UIKit

class PayCell: UITableViewCell {

    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var lbSize: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imageShoe: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func fillData(_ data: ProductCheckout) {
        imageShoe.getImageFrom(data.product.image)
        lbName.text = data.product.title
        lbSize.text = data.size.description
        lbPrice.text = data.product.price.intToMoney()
        lbNumber.text = data.quatity.description
    }
}
