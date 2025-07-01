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
        $0.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
    }
    
    @objc
    private func warningBtnDidTap() {
        let popupVC = WarningPopupViewController()
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            popupVC.dismiss(animated: false)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc
    private func backBtnDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
}
