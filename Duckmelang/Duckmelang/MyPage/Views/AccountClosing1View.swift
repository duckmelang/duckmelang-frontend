//
//  AccountClosingView.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class AccountClosing1View: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addStack()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backBtn = UIButton().then {
        $0.setImage(.back, for: .normal)
    }
    
    private lazy var title = Label(text: "계정 탈퇴", font: .aritaSemiBoldFont(ofSize: 18), color: .black)
    
    lazy var finishBtn = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var text1 = Label(text: "회원 탈퇴(이용약관 동의 철회)시", font: .ptdSemiBoldFont(ofSize: 16), color: .grey800)
    
    private lazy var text2 = Label(text: "아래 내용을 확인해주세요", font: .ptdSemiBoldFont(ofSize: 16), color: .grey800)
    
    private lazy var view = UIScrollView().then {
        $0.layer.cornerRadius = 7
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grey300?.cgColor
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = true
        $0.alwaysBounceVertical = true
        $0.alwaysBounceHorizontal = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    private lazy var text3 = Label(text: "이용약관 동의 철회를 위한 동의 철회 약관들 있다면 여기다 넣을게요\n 이용약관 동의 철회를 위한 동의 철회 약관들 있다면 여기다 넣을게요\n 이용약관 동의 철회를 위한 동의 철회 약관들 있다면 여기다 넣을게요\n 이용약관 동의 철회를 위한 동의 철회 약관들 있다면 여기다 넣을게요\n 이용약관 동의 철회를 위한 동의 철회 약관들 있다면 여기다 넣을게요\n 이용약관 동의 철회를 위한 동의 철회 약관들 있다면 여기다 넣을게요\n 이용약관 동의 철회를 위한 동의 철회 약관들 있다면 여기다 넣을게요\n 이용약관 동의 철회를 위한 동의 철회 약관들 있다면 여기다 넣을게요\n 이용약관 동의 철회를 위한 동의 철회 약관들 있다면 여기다 넣을게요", font: .ptdRegularFont(ofSize: 14), color: .grey500).then {
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    private lazy var text4 = Label(text: "회원 탈퇴(이용약관 동의 철회)를 하시겠습니까?", font: .ptdSemiBoldFont(ofSize: 16), color: .grey800)
    
    private lazy var outBtn = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("회원 탈퇴", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 17), .foregroundColor: UIColor.grey0!]))
        $0.configuration = config
        $0.backgroundColor = .dmrBlue
        $0.layer.cornerRadius = 23
        $0.clipsToBounds = true
    }
    
    private lazy var topStack = Stack(axis: .horizontal, distribution: .equalCentering, alignment: .center)
    
    private lazy var textStack = Stack(axis: .vertical, spacing: 5, alignment: .leading)
    
    private func addStack(){
        [backBtn, title, finishBtn].forEach{topStack.addArrangedSubview($0)}
        [text1, text2].forEach{textStack.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [topStack, textStack, view, text4, outBtn].forEach{addSubview($0)}
        view.addSubview(text3)
        
        topStack.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(42)
        }
        
        textStack.snp.makeConstraints{
            $0.top.equalTo(topStack.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        view.snp.makeConstraints{
            $0.top.equalTo(textStack.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(topStack.snp.width).inset(11)
            $0.height.equalTo(400)
        }
        
        text3.snp.makeConstraints{
            $0.top.equalToSuperview().inset(12)
            $0.leading.trailing.equalTo(view).inset(12)
            $0.width.equalToSuperview()
        }
        
        text4.snp.makeConstraints{
            $0.top.equalTo(view.snp.bottom).offset(25)
            $0.leading.equalToSuperview().inset(16)
        }
        
        outBtn.snp.makeConstraints{
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(46)
        }
    }
}
