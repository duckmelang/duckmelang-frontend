//
//  ProfileModifyViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class ProfileModifyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = profileModifyView
        
        navigationController?.isNavigationBarHidden = true
    }
    
    private lazy var profileModifyView = ProfileModifyView()

}
