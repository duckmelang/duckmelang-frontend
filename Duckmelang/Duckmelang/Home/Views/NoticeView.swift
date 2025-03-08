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
        
        private func setupView() {
            
            [
                noticeTableView
            ].forEach {
                addSubview($0)
            }
            
            noticeTableView.snp.makeConstraints {
                $0.top.equalTo(safeAreaLayoutGuide)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        }
    
}
