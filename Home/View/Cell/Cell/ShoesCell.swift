//
//  shoesCell.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 26/01/2022.
//

import UIKit

class ShoesCell: UICollectionViewCell {

    @IBOutlet weak var lableName: UILabel!
    @IBOutlet weak var lablePrice: UILabel!
    @IBOutlet weak var imageShoe: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageShoe.layer.cornerRadius = 20
        self.layer.cornerRadius = 5
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.masksToBounds = false
        // Initialization code
    }
    func fillData(_ data: ProductProtocol) {
        lablePrice.text = data.price.intToMoney()
        lableName.text = data.title
        imageShoe.getImageFrom(data.image)
    }
}
