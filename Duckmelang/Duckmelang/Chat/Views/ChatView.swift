//
//  ChatView.swift
//  Duckmelang
//
//  Created by 주민영 on 1/16/25.
//

import UIKit
import Then
import SnapKit

class ChatView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var allBtn = ChipButton(title: "전체", width: 47, tag: 0)
    lazy var ongoingBtn = ChipButton(title: "진행 중", width: 62, tag: 1)
    lazy var confirmBtn = ChipButton(title: "동행확정", width: 62, tag: 2)
    lazy var doneBtn = ChipButton(title: "종료", width: 47, tag: 3)
    
    lazy var btnStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .leading
        $0.spacing = 8
    }
    
    lazy var chatTableView = UITableView().then {
        $0.register(ChatCell.self, forCellReuseIdentifier: ChatCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 75
    }
    
    lazy var empty = emptyLabel(text: "채팅 목록이 없습니다")
    
    private func setupView() {
        btnStackView.addArrangedSubview(allBtn)
        btnStackView.addArrangedSubview(ongoingBtn)
        btnStackView.addArrangedSubview(confirmBtn)
        btnStackView.addArrangedSubview(doneBtn)
        
        [
            btnStackView,
            chatTableView,
            empty
        ].forEach {
            addSubview($0)
        }
        
        btnStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(250)
        }
        
        chatTableView.snp.makeConstraints {
            $0.top.equalTo(btnStackView.snp.bottom).offset(12)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        empty.snp.makeConstraints {
            $0.top.equalTo(btnStackView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
    }

}
