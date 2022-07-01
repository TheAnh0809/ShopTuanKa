//
//  DetailCell.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 10/02/2022.
//

import UIKit

@available(iOS 13.0, *)
class DetailCell: UITableViewCell {
    var lookMore: Bool = false {
        didSet {
            if lookMore == true {
                btnXemThem.setImage(UIImage(named: "up"), for: .normal)
            } else {
                btnXemThem.setImage(UIImage(named: "down"), for: .normal)
            }
        }
    }
    var actionBlock: (() -> Void)?
    @IBOutlet weak var btnXemThem: UIButton!
    @IBOutlet weak var lableDetail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func fillData(_ data: ProductProtocol) {
        lableDetail.text = data.decription.changeDetal()
    }
    @IBAction func clickXemThem(_ sender: Any) {
        actionBlock?()
    }
}
