//
//  MyPageView.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Then
import SnapKit

class MyPageView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addStack()
        setupView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var myPageTopView = MyPageTopView()
    
    private lazy var myInfoChange = Label(text: "내 정보 변경", font: .ptdSemiBoldFont(ofSize: 16), color: .black)
    
    private lazy var idolChange = myPageBtn(text: "아이들 변경")
    
    private lazy var postRecommendChange = myPageBtn(text: "게시글 추천 필터 변경")
    
    private lazy var setup = Label(text: "설정", font: .ptdSemiBoldFont(ofSize: 16), color: .black)
    
    private lazy var login = myPageBtn(text: "로그인 정보")
    
    private lazy var push = myPageBtn(text: "푸시알림")
    
    private lazy var logout = myPageBtn(text: "로그아웃")
    
    private lazy var out = myPageBtn(text: "계정 탈퇴").then {
        $0.setTitleColor(.errorPrimary, for: .normal)
    }
    
    private lazy var topBtnStack = Stack(axis: .vertical, spacing: 20)
    private lazy var bottomBtnStack = Stack(axis: .vertical, spacing: 20)
    private lazy var topStack = Stack(axis: .vertical, spacing: 22)
    private lazy var bottomStack = Stack(axis: .vertical, spacing: 22)
    
    private func addStack() {
        [idolChange, postRecommendChange].forEach{topBtnStack.addArrangedSubview($0)}
        [login, push, logout, out].forEach{bottomBtnStack.addArrangedSubview($0)}
        [myInfoChange, topBtnStack].forEach{topStack.addArrangedSubview($0)}
        [setup, bottomBtnStack].forEach{bottomStack.addArrangedSubview($0)}
    }
    
    private func setupView() {
        [myPageTopView, topStack, bottomStack].forEach{addSubview($0)}
        
        myPageTopView.snp.makeConstraints{
            $0.height.equalTo(200)
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        topStack.snp.makeConstraints{
            $0.top.equalTo(myPageTopView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(16)
        }
        
        bottomStack.snp.makeConstraints{
            $0.top.equalTo(topStack.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(16)
        }
        
        topBtnStack.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(8)
        }
        
        bottomBtnStack.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(8)
        }
    }
}
