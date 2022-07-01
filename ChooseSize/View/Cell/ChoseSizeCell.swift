//
//  ChoseSizeCell.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 14/02/2022.
//

import UIKit

class ChoseSizeCell: UITableViewCell {
    var avableQuantity: Int = -1
    var listSize: [ProductSize] = []
    var number: Int = 0 {
        didSet {
            lbNumber.text = number.description
        }
    }
    @IBOutlet weak var textSize: UILabel!
    var sizeChoose: Int = 0
    var actionBlock: (() -> Void)?
    var action2: (() -> Void)?
    var action3: (() -> Void)?
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var clvSize: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        lbNumber.text = "0"
        clvSize.registerTableViewCell("SizeCell", UIScreen.main.bounds.width/5, 40, .vertical)
        clvSize.dataSource = self
        clvSize.delegate = self
        view1.layer.borderWidth = 1
        view1.layer.borderColor = UIColor.gray.cgColor
        view2.layer.borderWidth = 1
        view2.layer.borderColor = UIColor.gray.cgColor
        view3.layer.borderWidth = 1
        view3.layer.borderColor = UIColor.gray.cgColor
        
        // Initialization code
    }
    func fillData(_ data: ProductProtocol) {
        ServiceAPI.share.getSizeOfProduct(idPro: data.id) { response, _ in
            DispatchQueue.main.sync {
                self.listSize = response!
                self.clvSize.reloadData()
                self.action2?()
            }
            
        }
    }
    func returnDataChose() -> (Int, Int) {
        for item in listSize {
            if sizeChoose == item.size {
                return (item.id, number)
            }
        }
        return (0, 0)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func clickCong(_ sender: Any) {
        if avableQuantity < 0 {
            number += 1
        } else {
            if number < avableQuantity {
                number += 1
            }
        }
    }
    @IBAction func clickTru(_ sender: Any) {
        if number > 0 {
            number -= 1
        }
    }
    
}
@available(iOS 13.0, *)
extension ChoseSizeCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listSize.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        let cell = clvSize.dequeueReusableCell(withReuseIdentifier: "SizeCell", for: indexPath) as? SizeCell
        cell!.lbSize.text = listSize[indexPath.row].size.description
        if listSize[indexPath.row].size != sizeChoose {
            cell!.check = false
        } else {
            cell!.check = true
        }
        cell!.actionBlock = {
            cell!.check = true
            self.sizeChoose = self.listSize[indexPath.row].size
            self.avableQuantity = self.listSize[indexPath.row].availableQuantity
            self.number = 0
            self.clvSize.reloadData()
            self.action3?()
        }
        return cell!
    }
}
