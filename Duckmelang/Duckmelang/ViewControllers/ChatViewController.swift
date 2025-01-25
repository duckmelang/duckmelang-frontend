//
//  ChatViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/9/25.
//

import UIKit

class ChatViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = false
        
        let btn = smallFilledCustomBtn(title: "메세지창 열기")
        self.view.addSubview(btn)
        
        btn.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        btn.addTarget(self, action: #selector(goMessage), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func goMessage() {
        let messageVC = MessageViewController()
        navigationController?.pushViewController(messageVC, animated: true)
    }
}
