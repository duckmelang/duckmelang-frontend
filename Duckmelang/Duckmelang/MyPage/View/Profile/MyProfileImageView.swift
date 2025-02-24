//
//  MyProfileImageView.swift
//  Duckmelang
//
//  Created by KoNangYeon on 2/21/25.
//

import UIKit

class MyProfileImageView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backBtn = UIButton().then {
        $0.setImage(.back, for: .normal)
    }
    
    lazy var imageTableView = UITableView().then {
        $0.register(ProfileImageCell.self, forCellReuseIdentifier: ProfileImageCell.identifier)
        $0.rowHeight = 470
        $0.separatorStyle = .none
        $0.tableFooterView = loadingIndicator
    }
    
    lazy var loadingIndicator = LoadingIndicator()
    
    private func setupView() {
        [
            backBtn,
            imageTableView
        ].forEach {
            addSubview($0)
        }
        
        backBtn.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide).inset(6)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(28)
        }
        
        imageTableView.snp.makeConstraints {
            $0.top.equalTo(backBtn.snp.bottom).offset(6)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
