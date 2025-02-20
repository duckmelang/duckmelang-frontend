//
//  SelectEventViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 2/17/25.
//


import UIKit

class SelectEventViewController: UIViewController {

    private let selectEventView = SelectEventView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(selectEventView)
        
        selectEventView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
