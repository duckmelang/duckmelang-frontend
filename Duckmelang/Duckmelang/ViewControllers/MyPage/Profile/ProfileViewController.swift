//
//  ProfileViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = profileView
    }

    private lazy var profileView = ProfileView()
    
}
