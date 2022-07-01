//
//  Home_ViewController.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 24/01/2022.
//

import UIKit
class HomeViewController: BaseViewController {
    var homeVM: HomeVM = HomeVM()
    @IBOutlet weak var collectionViewBrand: UICollectionView!
    @IBOutlet weak var collectionViewShoe: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        collectionViewBrand.registerTableViewCell(BrandCell.nameClass, collectionViewBrand.frame.height,
                                                  UIScreen.main.bounds.width/6 * 3/4, .horizontal)
        let leftSectionInset: CGFloat = 20
        let minimumInteritemSpacing: CGFloat = leftSectionInset / 2
        let widthItem = (UIScreen.main.bounds.width - CGFloat(minimumInteritemSpacing * 2) - (leftSectionInset * 2)) / 2
        collectionViewShoe.registerTableViewCell(ShoesCell.nameClass, widthItem,
                                                 UIScreen.main.bounds.width/2 * 3/4, .vertical) { layout in
            layout.minimumLineSpacing = minimumInteritemSpacing * 2
            layout.estimatedItemSize = .zero
            layout.minimumInteritemSpacing = minimumInteritemSpacing
            layout.sectionInset = UIEdgeInsets(top: leftSectionInset,
                                               left: leftSectionInset,
                                               bottom: leftSectionInset,
                                               right: leftSectionInset)
        }
       
        // Do any additional setup after loading the view.
        showLoading()
        homeVM.getBrandVM {
            self.collectionViewBrand.reloadData()
            self.dismisLoading()
        }
        homeVM.getProductVM {
            self.collectionViewShoe.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.isNavigationBarHidden = true
    }
}
@available(iOS 13.0, *)
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        switch collectionView {
        case collectionViewBrand :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandCell.nameClass,
                                                          for: indexPath) as? BrandCell
            let data = homeVM.listBrands[indexPath.row]
            if data.id == homeVM.brandChose {
                cell?.ischoose()
            } else {
                cell?.unchoose()
            }
            cell!.fillData(data)
            return cell!
        default :
            let cell = collectionViewShoe.dequeueReusableCell(withReuseIdentifier: ShoesCell.nameClass, for: indexPath)
            as? ShoesCell
            cell!.fillData(homeVM.listProduct[indexPath.row])
            return cell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collectionViewBrand :
            return homeVM.listBrands.count
        default :
            return homeVM.listProduct.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case collectionViewBrand :
            if self.homeVM.brandChose != homeVM.listBrands[indexPath.row].id {
                self.homeVM.brandChose = homeVM.listBrands[indexPath.row].id
                self.homeVM.getProductVM { [self] in
                    collectionViewBrand.reloadData()
                    collectionViewShoe.reloadData()
                }
            }
        default:
            self.pushView(storybard: UIStoryboard(name: "TabBar", bundle: nil),
                          nextView: DetailsViewController.self) { view in
                view.detailVM.mainProduct = self.homeVM.listProduct[indexPath.row]
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == homeVM.listProduct.count - 1 {
            homeVM.page += 1
            homeVM.getMoreProduct { [self] in
                collectionViewShoe.reloadData()
            }
        }
    }
}
