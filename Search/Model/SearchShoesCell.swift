//
//  SearchShoesCell.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 07/02/2022.
//

import UIKit

class SearchShoesCell: UITableViewCell {

    @IBOutlet weak var lableDate: UILabel!
    @IBOutlet weak var lableNameShoe: UILabel!
    @IBOutlet weak var imageShoe: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func filldata(_ data: ProductProtocol) {
        self.lableNameShoe.text = data.title
        self.imageShoe.getImageFrom(data.image)
        self.lableDate.text = data.updateAt.getDateOfTime()
    }
    func fillData(_ data: ProductOrdered) {
        self.lableNameShoe.text = data.product.title
        self.imageShoe.getImageFrom(data.product.image)
        self.lableDate.text = data.datetime.getDateOfTime()
    }
}
