//
//  SearchViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 2/1/25.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = searchView
        self.navigationController?.isNavigationBarHidden = false
        setupNavigationBar()
    }
        
    private lazy var searchView: SearchView = {
        let view = SearchView()
        return view
    }()
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .white
        
        self.navigationItem.title = "검색"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.aritaSemiBoldFont(ofSize: 18)]
        
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(goBack))
        leftBarButton.tintColor = .grey600
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
        }
        
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
        }
    

}
