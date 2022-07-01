//
//  TabBaViewController.swift
//  App Ban Giay
//
//  Created by Shi Ying Nguyen on 26/01/2022.
//

import UIKit

class TabBaViewController: UITabBarController {
    var customTabBarView = UIView(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBar.layer.shadowOpacity = 1.5
        tabBar.tintColor = baseColor
        tabBarController?.tabBar.isHidden = false
        self.setupTabBarUI()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            self.setupCustomTabBarFrame()
    }
    private func setupCustomTabBarFrame() {
            let height = self.view.safeAreaInsets.bottom + 64
            var tabFrame = self.tabBar.frame
            tabFrame.size.height = height
            tabFrame.origin.y = self.view.frame.size.height - height
            self.tabBar.frame = tabFrame
            self.tabBar.setNeedsLayout()
            self.tabBar.layoutIfNeeded()
            customTabBarView.frame = tabBar.frame
        }
    private func setupTabBarUI() {
        self.tabBar.layer.cornerRadius = 15
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = baseColor
        self.tabBar.unselectedItemTintColor = baseColor
        if #available(iOS 13.0, *) {
            let appearance = self.tabBar.standardAppearance
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            self.tabBar.standardAppearance = appearance
        } else {
            self.tabBar.shadowImage = UIImage()
            self.tabBar.backgroundImage = UIImage()
        }
    }
}
