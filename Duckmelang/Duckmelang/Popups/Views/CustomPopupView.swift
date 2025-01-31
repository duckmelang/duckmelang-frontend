//
//  CustomPopupView.swift
//  Duckmelang
//
//  Created by 주민영 on 1/19/25.
//

import UIKit

class CustomPopupView: UIView {
    init(
        userImage: UIImage,
        title: String,
        subTitle: String,
        leftBtnTitle: String,
        rightBtnTitle: String,
        height: CGFloat
    ) {
        super.init(frame: .zero)
        
        self.userImage.image = userImage
        self.title.text = title
        self.subTitle.text = subTitle
        
        if (leftBtnTitle == "") && (rightBtnTitle == "") {
            self.btnStackView.isHidden = true
        } else if (leftBtnTitle == "") {
            self.leftBtn.isHidden = true
            self.rightBtn.setTitle(rightBtnTitle, for: .normal)
        } else {
            self.leftBtn.setTitle(leftBtnTitle, for: .normal)
            self.rightBtn.setTitle(rightBtnTitle, for: .normal)
        }
        
        self.backgroundColor = .clear
        self.addSubview(self.panel)
        self.addSubview(self.popupView)
        
        [self.userImage, self.textStackView, self.btnStackView]
          .forEach(self.popupView.addSubview(_:))
        [self.title, self.subTitle]
          .forEach(self.textStackView.addArrangedSubview(_:))
        [self.leftBtn, self.rightBtn]
            .forEach(self.btnStackView.addArrangedSubview(_:))
        
        setupView()
        
        self.popupView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(height)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        self.userImage.layer.cornerRadius = self.userImage.frame.width / 2
        self.userImage.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var panel = UIButton().then {
        $0.backgroundColor = UIColor.grey800?.withAlphaComponent(0.6)
    }
    
    private lazy var popupView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 7
        $0.clipsToBounds = true
    }
    
    private lazy var userImage = UIImageView().then {
        $0.backgroundColor = .grey200
        $0.clipsToBounds = true
    }
    
    private lazy var textStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private lazy var title = UILabel().then {
        $0.textColor = .grey800
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .ptdMediumFont(ofSize: 15)
    }
    
    private lazy var subTitle = UILabel().then {
        $0.textColor = .grey500
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = .ptdRegularFont(ofSize: 12)
    }
    
    lazy var leftBtn = smallStorkeCustomBtn()
    lazy var rightBtn = smallFilledCustomBtn()
    
    private lazy var btnStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
    }
    
    func setupView() {
        self.panel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.userImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(48)
        }
        
        self.textStackView.snp.makeConstraints {
            $0.top.equalTo(userImage.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        self.btnStackView.snp.makeConstraints {
            $0.top.equalTo(textStackView.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
    }
}
