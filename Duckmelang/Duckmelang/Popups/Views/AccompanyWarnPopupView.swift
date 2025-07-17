//
//  AccompanyWarnPopupView.swift
//  Duckmelang
//
//  Created by nau on 7/17/25.
//

import UIKit
import SnapKit

class AccompanyWarnPopupView: UIView {
    
    private let reasons = ["상업적 광고 및 판매", "음란물/불건전한 만남 및 대화", "욕설/비방", "유출/사칭/사기", "욕설/비하", "기타"]
    
    var tableViewHeightConstraint: Constraint?

    var containerBottom: Constraint?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel = Label(text: "신고 사유를 선택해주세요", font: .ptdSemiBoldFont(ofSize: 17), color: .grey800).then {
        $0.textAlignment = .center
    }
    
    lazy var reasonLabel = paddingLabel(text: "사유를 선택해주세요.", font: .ptdRegularFont(ofSize: 15), color: .grey700).then {
        
        $0.textInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
     
        $0.textAlignment = .left
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.grey400?.cgColor
        $0.layer.borderWidth = 1
    }
    
    lazy var panel = UIButton().then {
        $0.backgroundColor = UIColor.grey800?.withAlphaComponent(0.6)
    }
    
    let tableView = UITableView().then {
        $0.isHidden = true //처음엔 숨김
        $0.separatorStyle = .none
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = UIColor.grey400?.cgColor
        $0.layer.borderWidth = 1
        $0.estimatedRowHeight = 50
        $0.isScrollEnabled = false
        $0.register(ReasonCell.self, forCellReuseIdentifier: ReasonCell.identifier)
    }
    
    lazy var toggleBtn = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        $0.tintColor = UIColor.grey400
    }

    lazy var container = UIView()
    
    private func setupLayout() {
        container.backgroundColor = .white
        container.layer.cornerRadius = 12
        self.addSubview(panel)
        self.addSubview(container)
        
        [titleLabel, reasonLabel, tableView, toggleBtn].forEach { container.addSubview($0) }
        
        container.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.85)
            $0.bottom.equalTo(tableView.snp.bottom).offset(20)
        }
        
        panel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        reasonLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(16)
            $0.trailing.equalTo(toggleBtn.snp.leading).offset(-8)
            $0.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(16)
            $0.trailing.equalTo(toggleBtn.snp.leading).offset(-8)
            self.tableViewHeightConstraint = $0.height.equalTo(44).constraint // 초기에는 0
        }
        
        toggleBtn.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.top).offset(45)
            $0.height.width.equalTo(20)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
}

