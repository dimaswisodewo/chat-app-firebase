//
//  MainTabBarViewController.swift
//  Chat App Firebase
//
//  Created by Dimas Wisodewo on 25/05/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: ProfileViewController())
        
        // Add icons
        vc1.tabBarItem.image = UIImage(systemName: "message")
        vc2.tabBarItem.image = UIImage(systemName: "person")
                
        setViewControllers([vc1, vc2], animated: true)
    }
}
