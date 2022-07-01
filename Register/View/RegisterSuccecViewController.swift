//
//  RegisterSuccecViewController.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 08/02/2022.
//

import UIKit

class RegisterSuccecViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.present(storybard: UIStoryboard(name: "TabBar", bundle: nil), nextView: TabBaViewController.self)
            self.navigationController?.popViewController(animated: true)
        }
    }
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
