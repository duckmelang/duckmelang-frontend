//
//  MyProfileView.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class ProfileView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addStack()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var backBtn = UIButton().then {
        $0.setImage(.back, for: .normal)
    }
    
    private lazy var myProfileTitle = Label(text: "내 프로필", font: .aritaSemiBoldFont(ofSize: 18), color: .black)
    
    private lazy var setBtn = UIButton().then {
        $0.setImage(.moreVertical, for: .normal)
    }
    
    private lazy var topStack = Stack(axis: .horizontal, distribution: .equalSpacing, alignment: .center)
    
    private lazy var profileImage = UIImageView().then {
        $0.image = .profile
    }
    
    private lazy var nickname = Label(text: "닉네임", font: .ptdSemiBoldFont(ofSize: 17), color: .black)
    
    private let genderAndAgeStack = MyPageTopView().genderAndAgeStack
    
    private lazy var post = Label(text: "게시글", font: .ptdRegularFont(ofSize: 12), color: .grey700)
    
    private lazy var matching = Label(text: "매칭횟수", font: .ptdRegularFont(ofSize: 12), color: .grey700)
    
    private lazy var postCount = Label(text: "80", font: .ptdSemiBoldFont(ofSize: 17), color: .grey800)
    
    private lazy var matchingCount = Label(text: "80", font: .ptdSemiBoldFont(ofSize: 17), color: .grey800)
    
    private lazy var nicknameAndInfo = Stack(axis: .vertical, spacing: 6)
    private lazy var postStack = Stack(axis: .vertical, spacing: 4, alignment: .center)
    private lazy var matchingStack = Stack(axis: .vertical, spacing: 4, alignment: .center)
    private lazy var postMatchingStack = Stack(axis: .horizontal, spacing: 25)
    private lazy var middleView = UIView()
    
    private lazy var backView = UIView().then {
        $0.layer.borderColor = UIColor.grey200?.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 7
    }
    
    private lazy var selfPR = Label(text: "메랑이 구해요!", font: .ptdRegularFont(ofSize: 12), color: .grey800)
    
    private func addStack(){
        [backBtn, myProfileTitle, setBtn].forEach{topStack.addArrangedSubview($0)}
        [nickname, genderAndAgeStack].forEach{nicknameAndInfo.addArrangedSubview($0)}
        [post, postCount].forEach{postStack.addArrangedSubview($0)}
        [matching, matchingCount].forEach{matchingStack.addArrangedSubview($0)}
        [postStack, matchingStack].forEach{postMatchingStack.addArrangedSubview($0)}
    }
        
    private func setupView(){
        [profileImage, nicknameAndInfo, postMatchingStack].forEach{middleView.addSubview($0)}
        [selfPR].forEach{backView.addSubview($0)}
        [topStack, middleView, backView].forEach{addSubview($0)}
        
        topStack.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(42)
        }
        
        middleView.snp.makeConstraints{
            $0.top.equalTo(topStack.snp.bottom).offset(2)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(68)
        }
        
        profileImage.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
            $0.height.width.equalTo(68)
        }
        
        nicknameAndInfo.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.left.equalTo(profileImage.snp.right).offset(16)
        }
        
        genderAndAgeStack.snp.makeConstraints{
            $0.top.equalTo(nickname.snp.bottom).offset(6)
            $0.left.equalTo(profileImage.snp.right).offset(16)
        }
        
        postMatchingStack.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
        }
        
        backView.snp.makeConstraints{
            $0.top.equalTo(middleView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(56)
        }
        
        selfPR.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }
    }
}

