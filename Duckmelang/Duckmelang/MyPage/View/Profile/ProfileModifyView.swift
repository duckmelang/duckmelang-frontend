//
//  MyProfileModifyView.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import SnapKit
import Then

class ProfileModifyView: UIView {
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
    
    private lazy var profileModifyTitle = Label(text: "프로필 수정", font: .aritaSemiBoldFont(ofSize: 18), color: .black)
    
    lazy var finishBtn = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("완료", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 13), .foregroundColor: UIColor.dmrBlue!]))
        $0.configuration = config
        $0.setTitleColor(.dmrBlue, for: .normal)
        $0.backgroundColor = .clear
    }
    
    lazy var profileImage = UIImageView().then {
        $0.image = UIImage(resource: .profileModify)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = $0.frame.height/2
    }
    
    lazy var profileAddBtn = UIButton().then {
        $0.setImage(.addBtn, for: .normal)
    }
    
    private lazy var nickname = Label(text: "닉네임", font: .ptdMediumFont(ofSize: 15), color: .grey700)
    
    private lazy var selfPR = Label(text: "자기소개", font: .ptdMediumFont(ofSize: 15), color: .grey700)
    
    lazy var nicknameTextField = TextField().then {
        $0.configLabel(text: "", font: .ptdMediumFont(ofSize: 15), color: .grey600!)
        $0.configLayer(layerBorderWidth: 1, layerCornerRadius: 5, layerColor: .grey400)
        $0.configTextField(placeholder: "닉네임을 입력해주세요", leftView: UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0)), leftViewMode: .always, interaction: true)
    }
    
    lazy var nicknameErrorText = Label(text: "닉네임을 정확히 입력해주세요.", font: .ptdMediumFont(ofSize: 13), color: .errorPrimary).then {
        $0.isHidden = true
    }
    
    lazy var selfPRTextField = TextField().then {
        $0.configLabel(text: "", font: .ptdMediumFont(ofSize: 15), color: .grey600!)
        $0.configLayer(layerBorderWidth: 1, layerCornerRadius: 5, layerColor: .grey400)
        $0.configTextField(placeholder: "자기소개를 입력해주세요", leftView: UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0)), leftViewMode: .always, interaction: true)
    }
    
    lazy var selfPRErrorText = Label(text: "자기소개를 정확히 입력해주세요.", font: .ptdMediumFont(ofSize: 13), color: .errorPrimary).then {
        $0.isHidden = true
    }
    
    lazy var alert = UIImageView().then {
        $0.image = UIImage(resource: .alert)
        $0.isUserInteractionEnabled = true
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    lazy var blurBackgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .dark)).then {
        $0.isHidden = true // 기본적으로 숨김
        $0.alpha = 0.5
    }
    
    private lazy var topStack = Stack(axis: .horizontal, distribution: .equalCentering, alignment: .center)
    private lazy var nicknameStack = Stack(axis: .vertical, spacing: 10, alignment: .leading)
    private lazy var selfPRStack = Stack(axis: .vertical, spacing: 10, alignment: .leading)
    private lazy var textFieldStack = Stack(axis: .vertical, spacing: 32, alignment: .leading)
    
    private func addStack(){
        [backBtn, profileModifyTitle, finishBtn].forEach{topStack.addArrangedSubview($0)}
        [nickname, nicknameTextField].forEach{nicknameStack.addArrangedSubview($0)}
        [selfPR, selfPRTextField].forEach{selfPRStack.addArrangedSubview($0)}
        [nicknameStack, selfPRStack].forEach{textFieldStack.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [topStack, profileImage, profileAddBtn, textFieldStack, nicknameErrorText, selfPRErrorText, blurBackgroundView, alert].forEach{addSubview($0)}
        
        
        blurBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview() // 화면 전체를 덮음
        }
        
        topStack.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(42)
        }
        
        profileImage.snp.makeConstraints{
            $0.top.equalTo(topStack.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(96)
        }
        
        profileAddBtn.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(profileImage)
            $0.height.width.equalTo(30)
        }
        
        textFieldStack.snp.makeConstraints{
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalTo(profileImage.snp.bottom).offset(28)
        }
        
        nicknameTextField.snp.makeConstraints{
            $0.height.equalTo(39)
            $0.width.equalTo(textFieldStack.snp.width)
        }
        
        nicknameErrorText.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(2)
        }
        
        selfPRTextField.snp.makeConstraints{
            $0.height.equalTo(39)
            $0.width.equalTo(textFieldStack.snp.width)
        }
        
        selfPRErrorText.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalTo(selfPRTextField.snp.bottom).offset(2)
        }
        
        alert.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(118)
        }
    }
}
