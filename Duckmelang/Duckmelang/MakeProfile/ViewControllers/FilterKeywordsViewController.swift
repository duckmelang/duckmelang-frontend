//
//  FilterKeywordsViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 2/17/25.
//


import UIKit

class FilterKeywordsViewController: UIViewController {

    private let filterKeywordsView = FilterKeywordsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(filterKeywordsView)
        
        filterKeywordsView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
