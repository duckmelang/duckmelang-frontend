//
//  RequestView.swift
//  Duckmelang
//
//  Created by 주민영 on 1/31/25.
//

import UIKit

class RequestView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var awaitingBtn = ChipButton(title: "대기 중", width: 62, tag: 0)
    lazy var sentBtn = ChipButton(title: "보낸 요청", width: 73, tag: 1)
    lazy var receivedBtn = ChipButton(title: "받은 요청", width: 73, tag: 2)
    
    lazy var btnStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .leading
        $0.spacing = 8
    }
    
    lazy var requestTableView = UITableView().then {
        $0.register(MyAccompanyCell.self, forCellReuseIdentifier: MyAccompanyCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 79
        $0.tableFooterView = loadingIndicator
    }
    
    let loadingIndicator = LoadingIndicator()
    
    lazy var empty = emptyLabel(text: "요청 목록이 없습니다")
    
    private func setupView() {
        btnStackView.addArrangedSubview(awaitingBtn)
        btnStackView.addArrangedSubview(sentBtn)
        btnStackView.addArrangedSubview(receivedBtn)
        
        [
            btnStackView,
            requestTableView,
            empty,
        ].forEach {
            addSubview($0)
        }
        
        btnStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(220)
        }
        
        requestTableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(66)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        empty.snp.makeConstraints {
            $0.top.equalTo(btnStackView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
    }
}
