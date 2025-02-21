//
//  OtherPostsView.swift
//  Duckmelang
//
//  Created by 주민영 on 2/21/25.
//

import UIKit

class OtherPostsView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var uploadPostView = UITableView().then {
        $0.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 106
        $0.tableFooterView = loadingIndicator
    }
    
    let loadingIndicator = LoadingIndicator()
    
    lazy var empty = emptyLabel(text: "업로드한 게시물이 없습니다")
    
    private func setupView(){
        [uploadPostView, empty].forEach{addSubview($0)}
        
        uploadPostView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(500)
        }
        
        empty.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.centerX.equalToSuperview()
        }
    }
}
