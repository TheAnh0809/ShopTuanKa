//
//  PayFalseViewController.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 08/02/2022.
//

import UIKit

class PayFalseViewController: BaseViewController {

    @IBOutlet weak var btnTry: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnTry.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
    }
    @IBAction func clickTryAgain(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
