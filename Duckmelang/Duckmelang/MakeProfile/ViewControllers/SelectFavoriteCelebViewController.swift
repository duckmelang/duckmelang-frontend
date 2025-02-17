//
//  SelectFavoriteCelebViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 2/17/25.
//


import UIKit

class SelectFavoriteCelebViewController: UIViewController {

    private let selectFavoriteCelebView = SelectFavoriteCelebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white  // 기본 배경색 설정
        view.addSubview(selectFavoriteCelebView)
        
        selectFavoriteCelebView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)  // safeAreaLayoutGuide에 맞게 배치
        }
    }
}
