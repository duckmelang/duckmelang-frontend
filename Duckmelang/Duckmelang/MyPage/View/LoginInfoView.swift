//
//  LoginInfo.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class LoginInfoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addStack()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var loginInfo: myPageLoginResponse? {
        didSet {
            if let loginInfo = loginInfo { //loginInfo가 nil이 아닐 때만 실행
                print("로그인정보 변경됨 \(loginInfo)") // 확인용로그
                updateLoginInfo() //인스턴스를 전달
            }
        }
    }
    
    lazy var backBtn = UIButton().then {
        $0.setImage(.back, for: .normal)
    }
    
    private lazy var loginTitle = Label(text: "로그인 정보", font: .aritaSemiBoldFont(ofSize: 18), color: .black)
    
    lazy var finishBtn = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var name = Label(text: "손서우 님", font: .ptdRegularFont(ofSize: 16), color: .black)
    
    private lazy var email = Label(text: "a01074177955@gmail.com", font: .ptdRegularFont(ofSize: 13), color: .grey600)
    
    private lazy var topStack = Stack(axis: .horizontal, distribution: .equalCentering, alignment: .center)
    
    private lazy var backStack = Stack(axis: .vertical, spacing: -36, distribution: .fillEqually ,alignment: .center).then {
        $0.layer.cornerRadius = 7
        $0.layer.borderColor = UIColor.grey200?.cgColor
        $0.layer.borderWidth = 1
    }
    
    private lazy var kakaoStack = Stack(axis: .horizontal, spacing: 8, alignment: .center)
    
    private lazy var googleStack = Stack(axis: .horizontal, spacing: 8, alignment: .center)
    
    private lazy var loginStack = Stack(axis: .vertical, spacing: 24)
    
    private lazy var kakaoIcon = UIImageView(image: UIImage(resource: .kakaoLogo))
    
    private lazy var googleIcon = UIImageView(image: UIImage(resource: .googleIcon))
    
    lazy var kakaoCheckIcon = UIImageView(image: UIImage(resource: .check)).then {
        $0.isHidden = true
    }
    
    lazy var googleCheckIcon = UIImageView(image: UIImage(resource: .check)).then {
        $0.isHidden = true
    }
    
    // 연동시 grey800, 오른쪽 checkIcon 표시
    lazy var kakaoText = Label(text: "카카오톡 이메일 연동", font: .ptdRegularFont(ofSize: 13), color: .grey600)
    
    lazy var googleText = Label(text: "구글 이메일 연동", font: .ptdRegularFont(ofSize: 13), color: .grey600)
    
    private func addStack(){
        [backBtn, loginTitle, finishBtn].forEach{topStack.addArrangedSubview($0)}
        [name, email].forEach{backStack.addArrangedSubview($0)}
        [kakaoIcon, kakaoText, kakaoCheckIcon].forEach{kakaoStack.addArrangedSubview($0)}
        [googleIcon, googleText, googleCheckIcon].forEach{googleStack.addArrangedSubview($0)}
        [kakaoStack, googleStack].forEach{loginStack.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [topStack, backStack, loginStack].forEach{addSubview($0)}
        
        topStack.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(42)
        }
        
        backStack.snp.makeConstraints{
            $0.top.equalTo(topStack.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(84)
        }
    
        loginStack.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(24)
            $0.top.equalTo(backStack.snp.bottom).offset(20)
        }
        
        kakaoIcon.snp.makeConstraints{
            $0.height.width.equalTo(24)
        }
        
        googleIcon.snp.makeConstraints{
            $0.height.width.equalTo(24)
        }
    }
    
    /// ✅ 로그인 정보를 UI에 반영하는 메서드
    func updateLoginInfo() {
        guard let loginInfo = loginInfo else { return }
        
        name.text = "\(loginInfo.nickname) 님"
        email.text = loginInfo.email
        
        // ✅ 카카오톡 연동 여부에 따라 UI 변경
        if loginInfo.kakaoLinked {
            kakaoCheckIcon.isHidden = false
            kakaoText.textColor = .grey800
        } else {
            kakaoCheckIcon.isHidden = true
            kakaoText.textColor = .grey600
        }
        
        // ✅ 구글 연동 여부에 따라 UI 변경
        if loginInfo.googleLinked {
            googleCheckIcon.isHidden = false
            googleText.textColor = .grey800
        } else {
            googleCheckIcon.isHidden = true
            googleText.textColor = .grey600
        }
    }
}
