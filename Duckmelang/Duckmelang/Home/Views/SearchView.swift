//
//  SearchView.swift
//  Duckmelang
//
//  Created by 김연우 on 2/1/25.
//

import UIKit
import Then
import SnapKit

class SearchView: UIView {
    
    let searchTextField = UITextField().then {
        $0.placeholder = "텍스트 입력"
        $0.borderStyle = .roundedRect

        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        $0.leftView = leftPaddingView
        $0.leftViewMode = .always

        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .gray
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        searchIcon.center = CGPoint(x: rightPaddingView.frame.width / 2, y: rightPaddingView.frame.height / 2)
        rightPaddingView.addSubview(searchIcon)

        $0.rightView = rightPaddingView
        $0.rightViewMode = .always
    }
    
    let recentSearchView0 = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let recentSearchView1 = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let recentSearchTableView = UITableView().then {
        $0.register(RecentSearchCell.self, forCellReuseIdentifier: "RecentSearchCell")
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 44
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [
            searchTextField,
            recentSearchView0,
            recentSearchView1
        ].forEach {
            addSubview($0)
        }
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(safeAreaLayoutGuide).offset(10)
            $0.height.equalTo(40)
        }
        
        recentSearchView0.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(searchTextField.snp.bottom).offset(10)
            $0.width.equalTo(180)
            $0.height.equalTo(40)
        }

        recentSearchView1.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(searchTextField.snp.bottom).offset(10)
            $0.width.equalTo(190)
            $0.height.equalTo(300)
        }
        
        recentSearchView1.addSubview(recentSearchTableView)
        recentSearchTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
    }
}
