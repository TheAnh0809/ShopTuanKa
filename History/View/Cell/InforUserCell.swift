//
//  InforUserCell.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 19/02/2022.
//

import UIKit

class InforUserCell: UITableViewCell {
    var actionAvatar: (() -> Void)?
    @IBOutlet weak var lbAnh: UILabel!
    @IBOutlet weak var imageAvata: UIImageView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var lbOrder: UILabel!
    @IBOutlet weak var lbName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageAvata.toCircle()
        imageAvata.layer.borderWidth = 1
        imageAvata.layer.borderColor = baseColor.cgColor
        let tapGestureRecognizer =
        UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 2
        imageAvata.isUserInteractionEnabled = true
        imageAvata.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        actionAvatar?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func fillData(_ data: ProfileUser) {
        if data.image.isEmpty == false {
            imageAvata.getImageFrom("/" + data.image)
            lbAnh.isHidden = true
        }
        lbName.text = "Tên: " + data.fullName
        
    }
}
