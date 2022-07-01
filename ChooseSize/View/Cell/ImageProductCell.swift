//
//  ImageProductCell.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 14/02/2022.
//

import UIKit

class ImageProductCell: UITableViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var imageProduct: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func fillData(_ data: ProductProtocol) {
        imageProduct.getImageFrom(data.image)
        lbName.text = data.title
    }
}
