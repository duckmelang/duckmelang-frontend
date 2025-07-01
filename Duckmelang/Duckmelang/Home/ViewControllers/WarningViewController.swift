//
//  WarningViewController.swift
//  Duckmelang
//
//  Created by nau on 6/30/25.
//

import Foundation
import UIKit

class WarningViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = warningView
    }
    
    private lazy var warningView = WarningView().then {
        $0.warningBtn.addTarget(self, action: #selector(warningBtnDidTap), for: .touchUpInside)
    }
    
    @objc
    private func warningBtnDidTap() {
        let popupVC = WarningPopupViewController()
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false)
    }
}
