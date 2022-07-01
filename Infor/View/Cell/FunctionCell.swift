//
//  FunctionCell.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 20/02/2022.
//

import UIKit

class FunctionCell: UITableViewCell {
    var actionHistory: (() -> Void)?
    var actionAddress: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickNotifi(_ sender: Any) {
    }
    @IBAction func clickCard(_ sender: Any) {
    }
    @IBAction func clickAdress(_ sender: Any) {
        actionAddress?()
    }
    @IBAction func cliclHistory(_ sender: Any) {
        actionHistory?()
    }
    @IBAction func clickHelp(_ sender: Any) {
    }
}
