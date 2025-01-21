//
//  HomeViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/9/25.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
    }
    
    private lazy var homeView: HomeView = {
        let view = HomeView()
        return view
    }()
}
