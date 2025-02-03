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
    
    private func setupView() {
        [
            segmentedControl,
            underLineView,
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
    }

}
