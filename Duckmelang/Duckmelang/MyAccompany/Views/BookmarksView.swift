//
//  BookmarksView.swift
//  Duckmelang
//
//  Created by 주민영 on 1/31/25.
//

import UIKit

class BookmarksView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var bookmarksTableView = UITableView().then {
        $0.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 106
        $0.tableFooterView = loadingIndicator
    }
    
    let loadingIndicator = LoadingIndicator()
    
    lazy var empty = emptyLabel(text: "스크랩 목록이 없습니다")
    
    private func setupView() {
        [
            bookmarksTableView,
            empty,
        ].forEach {
            addSubview($0)
        }
        
        bookmarksTableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        empty.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
        }
    }
}
