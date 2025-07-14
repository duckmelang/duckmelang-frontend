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
        addStack()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backBtn = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var title = Label(text: "나의 동행", font: .aritaSemiBoldFont(ofSize: 18), color: .black)
    
    lazy var finishBtn = UIButton().then {
        $0.setImage(.bell, for: .normal)
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
    
    private lazy var topStack = Stack(axis: .horizontal, distribution: .equalCentering, alignment: .center)
    
    private func addStack(){
        [backBtn, title, finishBtn].forEach{topStack.addArrangedSubview($0)}
    }
    
    private func setupView() {
        [
            topStack,
            segmentedControl,
            underLineView,
        ].forEach {
            addSubview($0)
        }
        
        topStack.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(42)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(topStack.snp.bottom).offset(9)
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
