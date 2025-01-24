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
    
    private lazy var profileImage = UIImageView().then {
        $0.image = UIImage(resource: .profileModify)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = $0.frame.height/2
    }
    
    private lazy var profileAddBtn = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(resource: .add)
        $0.configuration = config
        $0.backgroundColor = .clear
    }
    
    private lazy var nickname = Label(text: "닉네임", font: .ptdMediumFont(ofSize: 15), color: .grey700)
    
    private lazy var selfPR = Label(text: "자기소개", font: .ptdMediumFont(ofSize: 15), color: .grey700)
    
    private lazy var nicknameTextFiled = TextField().then {
        $0.configLabel(text: "", font: .ptdMediumFont(ofSize: 15), color: .grey600!)
        $0.configLayer(layerBorderWidth: 1, layerCornerRadius: 5, layerColor: .grey400)
        $0.configTextField(placeholder: "닉네임을 입력해주세요", leftView: UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0)), leftViewMode: .always, interaction: true)
    }
    
    private lazy var selfPRTextFiled = TextField().then {
        $0.configLabel(text: "", font: .ptdMediumFont(ofSize: 15), color: .grey600!)
        $0.configLayer(layerBorderWidth: 1, layerCornerRadius: 5, layerColor: .grey400)
        $0.configTextField(placeholder: "자기소개를 입력해주세요", leftView: UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0)), leftViewMode: .always, interaction: true)
    }
    
    private lazy var topStack = Stack(axis: .horizontal, distribution: .equalCentering, alignment: .center)
    private lazy var nicknameStack = Stack(axis: .vertical, spacing: 10, alignment: .leading)
    private lazy var selfPRStack = Stack(axis: .vertical, spacing: 10, alignment: .leading)
    private lazy var textFieldStack = Stack(axis: .vertical, spacing: 32, alignment: .leading)
    
    private func addStack(){
        [backBtn, profileModifyTitle, finishBtn].forEach{topStack.addArrangedSubview($0)}
        [nickname, nicknameTextFiled].forEach{nicknameStack.addArrangedSubview($0)}
        [selfPR, selfPRTextFiled].forEach{selfPRStack.addArrangedSubview($0)}
        [nicknameStack, selfPRStack].forEach{textFieldStack.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [topStack, profileImage, profileAddBtn, textFieldStack].forEach{addSubview($0)}
        
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
        
        nicknameTextFiled.snp.makeConstraints{
            $0.height.equalTo(39)
            $0.width.equalTo(textFieldStack.snp.width)
        }
        
        selfPRTextFiled.snp.makeConstraints{
            $0.height.equalTo(39)
            $0.width.equalTo(textFieldStack.snp.width)
        }
    }
}
