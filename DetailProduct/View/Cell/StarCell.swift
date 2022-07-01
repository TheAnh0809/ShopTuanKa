//
//  StarCell.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 10/02/2022.
//

import UIKit

@available(iOS 13.0, *)
class StarCell: UITableViewCell {

    @IBOutlet weak var btnLike: UIButton!

    @IBOutlet weak var nameShoe: UILabel!
    @IBOutlet weak var imageShoe: UIImageView!
    var actionBlock: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        imageShoe.layer.cornerRadius = 20
    }
    func fillData(_ data: ProductProtocol) {
        imageShoe.getImageFrom(data.image)
        nameShoe.text = data.title
    }
    @IBAction func clickTim(_ sender: Any) {
        actionBlock?()
    }
}
