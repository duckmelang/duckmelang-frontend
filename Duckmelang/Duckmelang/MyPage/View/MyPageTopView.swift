//
//  MyPageTopView.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Kingfisher

class MyPageTopView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addStack()
        setupView()
    }
    
    var profileData: ProfileData? {
        didSet {
            if let profile = profileData { //profileData가 nil이 아닐 때만 실행
                print("profileData 변경됨: \(profile)") // 확인용로그
                updateProfile(with: profile) //인스턴스를 전달
            }
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backView = UIView().then {
        $0.layer.borderColor = UIColor.grey200?.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 7
    }
    
    lazy var profileImage = UIImageView().then {
        $0.image = .profile
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 24
        $0.clipsToBounds = true
    }
    
    lazy var nickname = Label(text: "닉네임", font: .ptdMediumFont(ofSize: 16), color: .black)
    
    private lazy var gender = Label(text: "여성", font: .ptdRegularFont(ofSize: 13), color: .grey600)

    private lazy var line = Label(text: "|", font: .ptdMediumFont(ofSize: 13), color: .grey400)
    
    private lazy var age = Label(text: "나이", font: .ptdRegularFont(ofSize: 13), color: .grey600)
    
    lazy var profileSeeBtn = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        $0.backgroundColor = .dmrBlue
        config.attributedTitle = AttributedString("프로필 보기", attributes: AttributeContainer([.font: UIFont.ptdBoldFont(ofSize: 13), .foregroundColor: UIColor.grey100!]))
        $0.layer.cornerRadius = 5
        $0.configuration = config
    }

    lazy var genderAndAgeStack = Stack(axis: .horizontal, spacing: -24, distribution: .equalSpacing)
    lazy var nicknameAndInfo = Stack(axis: .vertical, spacing: 6)
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
        
        profileImage.snp.makeConstraints{
            $0.height.width.equalTo(48)
        }
        
        profileInfo.snp.makeConstraints{
            $0.left.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        profileSeeBtn.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    //UI 업데이트 함수 추가
    func updateProfile(with data: ProfileData) {
        nickname.text = data.nickname
        gender.text = data.localizedGender
        age.text = data.localizedAge
        
        //Kingfisher로 이미지 로딩 (URL이 유효한 경우만)
        if let url = URL(string: data.latestPublicMemberProfileImage) {
            profileImage.kf.setImage(
                with: url,
                placeholder: UIImage(resource: .profile) // 로딩 전 기본 이미지
            )
        }
    }
}
