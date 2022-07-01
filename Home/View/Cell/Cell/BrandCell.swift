//
//  BrandCell.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 26/01/2022.
//

import UIKit
import Kingfisher
class BrandCell: UICollectionViewCell {

    @IBOutlet weak var line: UIView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var imageBrand: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageBrand.layer.shadowColor = baseColor.cgColor
        imageBrand.layer.shadowRadius = 1.0
        imageBrand.layer.shadowOpacity = 0.5
        imageBrand.layer.shadowOffset = CGSize(width: 3, height: 3)
        imageBrand.layer.masksToBounds = false
        line.isHidden = true
        // Initialization code
    }
    func ischoose() {
        imageBrand.layer.shadowOffset = CGSize(width: 6, height: 6)
        line.isHidden = false
    }
    func unchoose() {
        imageBrand.layer.shadowOffset = CGSize(width: 3, height: 3)
        line.isHidden = true
    }
     func fillData(_ data: Brand) {
         imageBrand.getImageFrom( data.image)
    }
    
}
