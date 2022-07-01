//
//  SizeCell.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 07/02/2022.
//

import UIKit

@available(iOS 13.0, *)
class SizeCell: UICollectionViewCell {
    
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lbSize: UILabel!
    var check: Bool = false {
        didSet {
            changBtn()
        }
    }
    var actionBlock: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        // Initialization code
    }
    func changBtn() {
        if check == false {
            btnCheck.setImage(UIImage(named: "uncheck"), for: .normal)
            lbSize.textColor = .black
        } else {
            btnCheck.setImage(UIImage(named: "checked"), for: .normal)
            
            lbSize.textColor = baseColor
        }
    }
    @IBAction func clickcheck(_ sender: Any) {
        actionBlock?()
    }
}
