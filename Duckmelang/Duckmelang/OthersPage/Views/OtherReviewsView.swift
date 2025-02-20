//
//  OtherReviewsView.swift
//  Duckmelang
//
//  Created by 주민영 on 2/21/25.
//

import UIKit
import Cosmos

class OtherReviewsView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        addStack()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var reviewTableView = UITableView().then {
        $0.register(ReviewCell.self, forCellReuseIdentifier: ReviewCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 72
    }
    
    lazy var cosmosView = CosmosView().then {
        $0.rating = 4.8 // 평점
        $0.settings.updateOnTouch = false // 터치 비활성화 옵션
        $0.settings.fillMode = .precise // 별 채우기 모드 full(완전히), half(절반), precise(터치 및 입력한 곳까지 소수점으로)
        $0.settings.starSize = 25 // 별 크기
        $0.settings.starMargin = 6.4 // 별 간격
        
        // 이미지 변경
        // 이미지를 변경할 경우 색상은 적용되지 않는다. (색상이 들어간 이미지를 사용해야 한다.)
        $0.settings.filledImage = UIImage(resource: .star)
        $0.settings.emptyImage = UIImage(resource: .emptyStar)
    }
    
    lazy var cosmosCount = Label(text: String(cosmosView.rating), font: .ptdSemiBoldFont(ofSize: 17), color: .mainColor)
    
    private lazy var cosmosFive = Label(text: "/ 5", font: .ptdRegularFont(ofSize: 17), color: .grey600)
    
    lazy var cosmosStack = Stack(axis: .horizontal, spacing: 3)

    private func addStack(){
        [cosmosCount, cosmosFive].forEach{cosmosStack.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [reviewTableView, cosmosView, cosmosStack].forEach{addSubview($0)}
        
        cosmosView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(25)
        }
        
        cosmosStack.snp.makeConstraints{
            $0.top.equalTo(cosmosView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(25)
        }
        
        reviewTableView.snp.makeConstraints{
            $0.top.equalTo(cosmosStack.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview().inset(4)
            $0.height.equalTo(500)
        }
    }
}
