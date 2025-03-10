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
    private let myAccompanyVC = UINavigationController(rootViewController: MyAccompanyViewController())
    private let myPageVC = UINavigationController(rootViewController: MyPageViewController())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.viewControllers = [homeVC, chatVC, myAccompanyVC, myPageVC]
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .white
        tabBarAppearance.shadowColor = UIColor(hex: "#FBF8F0")
        self.tabBar.scrollEdgeAppearance = tabBarAppearance
        
        self.tabBar.tintColor = .black
        
        homeVC.tabBarItem = UITabBarItem(title: "메인", image: UIImage(named: "Home"), tag: 0)
        chatVC.tabBarItem = UITabBarItem(title: "채팅", image: UIImage(named: "Message"), tag: 1)
        myAccompanyVC.tabBarItem = UITabBarItem(title: "나의 동행", image: UIImage(named: "Union"), tag: 2)
        myPageVC.tabBarItem = UITabBarItem(title: "마이", image: UIImage(named: "Person"), tag: 3)
        
        self.selectedIndex = 0
    }
}
