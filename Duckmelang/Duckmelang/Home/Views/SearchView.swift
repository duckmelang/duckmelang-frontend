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

    let recentSearchLabel = UILabel().then {
        $0.text = "최근 검색어"
        $0.font = .ptdRegularFont(ofSize: 15)
        $0.textColor = .grey700
        $0.textAlignment = .left
    }
    
    let recentSearchTableView = UITableView().then {
        $0.register(RecentSearchCell.self, forCellReuseIdentifier: "RecentSearchCell")
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 44
        $0.allowsSelection = false
        $0.tag = 0
    }
    
    lazy var searchDataTableView = UITableView().then {
        $0.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 106
        $0.tableFooterView = loadingIndicator
        $0.isHidden = true
        $0.tag = 1
    }
    
    let loadingIndicator = LoadingIndicator()
    
    lazy var empty = emptyLabel(text: "검색 결과가 존재하지 않습니다")

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
            recentSearchLabel,
            recentSearchTableView,
            searchDataTableView,
            empty
        ].forEach {
            addSubview($0)
        }
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalTo(safeAreaLayoutGuide).offset(10)
            $0.height.equalTo(40)
        }
        
        recentSearchLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(25)
            $0.top.equalTo(searchTextField.snp.bottom).offset(15)
            $0.width.equalTo(180)
            $0.height.equalTo(40)
        }
        
        recentSearchTableView.snp.makeConstraints {
            $0.leading.equalTo(recentSearchLabel.snp.trailing).offset(5)
            $0.trailing.equalToSuperview()
            $0.top.equalTo(searchTextField.snp.bottom).offset(15)
            $0.bottom.equalToSuperview()
        }
        
        searchDataTableView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(10)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        empty.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}
