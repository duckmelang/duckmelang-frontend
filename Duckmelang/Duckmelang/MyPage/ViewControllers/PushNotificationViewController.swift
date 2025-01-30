//
//  PushNotificationViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class PushNotificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = pushNotificationView
        
        navigationController?.isNavigationBarHidden = true
    }

    private lazy var pushNotificationView = PushNotificationView()

}
