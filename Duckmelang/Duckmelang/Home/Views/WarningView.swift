//
//  WarningView.swift
//  Duckmelang
//
//  Created by nau on 6/30/25.
//

import Foundation
import UIKit

class WarningView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
  
        addStack()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backBtn = UIButton().then {
        $0.setImage(.back, for: .normal)
    }
    
    private lazy var title = Label(text: "신고하기", font: .aritaSemiBoldFont(ofSize: 18), color: .black)
    
    lazy var finishBtn = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    lazy var advert = customWarningBtn(text: "상업적 광고 및 판매")
    lazy var inappr = customWarningBtn(text: "게시판 성격에 부적절함")
    lazy var sexual = customWarningBtn(text: "음란물/불건전한 만남 및 대화")
    lazy var fraud = customWarningBtn(text: "유출/사칭/사기")
    lazy var insult = customWarningBtn(text: "욕설/비하")
    lazy var etc = customWarningBtn(text: "기타")
    
    lazy var warningBtn = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("신고", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 17), .foregroundColor: UIColor.grey0!]))
        $0.configuration = config
        $0.backgroundColor = .grey400
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    private lazy var topStack = Stack(axis: .horizontal, distribution: .equalCentering, alignment: .center)
    
    private lazy var warnStack = Stack(axis: .vertical, alignment: .leading).then {
        $0.isUserInteractionEnabled = true
    }
    
    private func addStack(){
        [backBtn, title, finishBtn].forEach{topStack.addArrangedSubview($0)}
        [advert, inappr, sexual, fraud, insult, etc].forEach{warnStack.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [topStack, warnStack, warningBtn].forEach{addSubview($0)}
        
        topStack.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(42)
        }
        
        warnStack.snp.makeConstraints{
            $0.top.equalTo(topStack.snp.bottom)
            $0.width.equalToSuperview()
        }
        
        warningBtn.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(45)
        }
    }
}
