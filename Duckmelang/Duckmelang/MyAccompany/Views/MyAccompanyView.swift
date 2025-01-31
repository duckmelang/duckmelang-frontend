//
//  MyAccompanyView.swift
//  Duckmelang
//
//  Created by 주민영 on 1/14/25.
//

import UIKit
import Then
import SnapKit

class MyAccompanyView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let segmentedControl = UISegmentedControl(items: ["요청", "스크랩", "내 게시글"]).then {
        $0.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        $0.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        $0.setBackgroundImage(UIImage(), for: .highlighted, barMetrics: .default)
        $0.setDividerImage(UIImage(), forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        
        $0.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.grey900!,
            .font: UIFont.ptdSemiBoldFont(ofSize: 17)
        ], for: .selected)
        
        $0.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.grey400!,
            .font: UIFont.ptdSemiBoldFont(ofSize: 17)
        ], for: .normal)
        $0.selectedSegmentIndex = 0
    }
    
    lazy var underLineView = UIView().then {
        $0.backgroundColor = .black
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
    
    lazy var myAccompanyTableView = UITableView().then {
        $0.register(MyAccompanyCell.self, forCellReuseIdentifier: MyAccompanyCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 79
        $0.isHidden = false
    }
    
    lazy var scrapTableView = UITableView().then {
        $0.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 106
        $0.isHidden = true
    }
    
    lazy var myPostsTableView = UITableView().then {
        $0.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 106
        $0.isHidden = true
    }
    
    private func setupView() {
        btnStackView.addArrangedSubview(awaitingBtn)
        btnStackView.addArrangedSubview(sentBtn)
        btnStackView.addArrangedSubview(receivedBtn)
        
        [
            segmentedControl,
            underLineView,
            btnStackView,
            myAccompanyTableView,
            scrapTableView,
            myPostsTableView
        ].forEach {
            addSubview($0)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.leading.equalTo(segmentedControl.snp.leading)
            $0.width.equalTo(segmentedControl.snp.width).multipliedBy(0.333)
            $0.height.equalTo(1)
        }
        
        btnStackView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(220)
        }
        
        myAccompanyTableView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(66)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        scrapTableView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(12)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        myPostsTableView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(12)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }

}
