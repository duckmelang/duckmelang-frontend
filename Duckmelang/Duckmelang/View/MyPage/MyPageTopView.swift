//
//  MyPageTopView.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class MyPageTopView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addStack()
        setupView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var backView = UIView().then {
        $0.layer.borderColor = UIColor.grey200?.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 7
    }
    
    private lazy var profileImage = UIImageView().then {
        $0.image = .profile
        $0.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        $0.layer.cornerRadius = $0.frame.height/2
        $0.clipsToBounds = true
    }
    
    private lazy var nickname = Label(text: "닉네임", font: .ptdMediumFont(ofSize: 16), color: .black)
    
    private lazy var gender = Label(text: "여성", font: .ptdMediumFont(ofSize: 13), color: .grey600)
    
    private lazy var line = Label(text: "ㅣ", font: .ptdMediumFont(ofSize: 13), color: .grey400)
    
    private lazy var age = Label(text: "나이", font: .ptdMediumFont(ofSize: 13), color: .grey600)
    
    lazy var profileSeeBtn = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        $0.backgroundColor = .dmrBlue
        config.attributedTitle = AttributedString("프로필 보기", attributes: AttributeContainer([.font: UIFont.ptdBoldFont(ofSize: 13), .foregroundColor: UIColor.grey100!]))
        $0.layer.cornerRadius = 5
        $0.configuration = config
        
    }

    lazy var genderAndAgeStack = Stack(axis: .horizontal, spacing: 1)
    private lazy var nicknameAndInfo = Stack(axis: .vertical, spacing: 6)
    private lazy var profileInfo = Stack(axis: .horizontal, spacing: 12, alignment: .center)
    
    private func addStack() {
        [gender, line, age].forEach{genderAndAgeStack.addArrangedSubview($0)}
        [nickname, genderAndAgeStack].forEach{nicknameAndInfo.addArrangedSubview($0)}
        [profileImage,nicknameAndInfo].forEach{profileInfo.addArrangedSubview($0)}
    }
    
    private func setupView() {
        [backView].forEach{addSubview($0)}
        [profileInfo, profileSeeBtn].forEach{backView.addSubview($0)}
        
        backView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.left.equalTo(safeAreaLayoutGuide).inset(16)
            $0.top.equalTo(safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(88)
        }
        
        profileInfo.snp.makeConstraints{
            $0.left.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        profileSeeBtn.snp.makeConstraints{
            $0.right.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
