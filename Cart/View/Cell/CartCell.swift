//
//  CartCell.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 14/02/2022.
//

import UIKit

@available(iOS 13.0, *)
class CartCell: UITableViewCell {
    var actionBlock: (() -> Void)?
    @IBOutlet weak var imageShoe: UIImageView!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var lbSize: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbName: UILabel!
    var check: Bool = true {
        didSet {
            if check == true {
                btnCheck.setImage(UIImage(named: "checked"), for: .normal)
            } else {
                btnCheck.setImage(UIImage(named: "uncheck"), for: .normal)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        check = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func fillData(_ data: ItemOfCart) {
        imageShoe.getImageFrom(data.imgURL)
        lbName.text = data.title
        lbPrice.text = data.price.intToMoney()
        lbSize.text = "Size: " + data.size.description
        lbNumber.text = "Số lượng: " + data.quantity.description
    }
    @IBAction func clickCheck(_ sender: Any) {
        actionBlock?()
    }
    
}
