//
//  CheckNicknamePopupViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 4/2/25.
//

import UIKit

class CheckNicknamePopupViewController: UIViewController {
    var isAvailable: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let isAvailable = isAvailable {
            let view = CheckNicknamePopupView(isAvailable: isAvailable)
            view.btn.addTarget(self, action: #selector(dismissPopup), for: .touchUpInside)
            self.view = view
        }
    }
    
    @objc private func dismissPopup() {
        dismiss(animated: false)
    }
}
