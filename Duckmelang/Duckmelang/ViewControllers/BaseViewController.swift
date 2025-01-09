//
//  BaseViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/9/25.
//

import UIKit

class BaseViewController: UITabBarController {
    private let homeVC = UINavigationController(rootViewController: HomeViewController())
    private let chatVC = UINavigationController(rootViewController: ChatViewController())
    private let myPageVC = UINavigationController(rootViewController: MyPageViewController())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.viewControllers = [homeVC, chatVC, myPageVC]
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .white
        tabBarAppearance.shadowColor = UIColor(hex: "#FBF8F0")
        self.tabBar.scrollEdgeAppearance = tabBarAppearance
        
        self.tabBar.tintColor = .black
        
        homeVC.tabBarItem = UITabBarItem(title: "메인", image: UIImage(named: "Home"), tag: 0)
        chatVC.tabBarItem = UITabBarItem(title: "채팅", image: UIImage(named: "Message"), tag: 1)
        myPageVC.tabBarItem = UITabBarItem(title: "마이", image: UIImage(named: "Person"), tag: 2)
        
        self.selectedIndex = 0
    }
}
