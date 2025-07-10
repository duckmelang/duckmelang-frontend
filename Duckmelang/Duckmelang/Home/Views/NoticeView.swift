//
//  NoticeView.swift
//  Duckmelang
//
//  Created by 김연우 on 2/1/25.
//

import UIKit
import Then
import SnapKit

class NoticeView: UIView {
    
    let noticeTableView = UITableView().then {
        $0.register(NoticeCell.self, forCellReuseIdentifier: NoticeCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 106
        $0.isHidden = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var navibar = CustomNavigationBar(title: "알림", leftImageName: "back")
    
    private func setupView() {
        [
            navibar,
            noticeTableView
        ].forEach {
            addSubview($0)
        }
        
        navibar.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(42)
        }
        
        noticeTableView.snp.makeConstraints {
            $0.top.equalTo(navibar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}
