//
//  TopMessageView.swift
//  Duckmelang
//
//  Created by 주민영 on 1/27/25.
//

import UIKit

class TopMessageView: UIView {
    init(isMyFirstMessage: Bool) {
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
        setupView()
        
        if (isMyFirstMessage) {
            confirmBtn.isHidden = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var main = UIView().then {
        $0.backgroundColor = .white
        
        $0.layer.cornerRadius = 5
        $0.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        $0.layer.borderColor = UIColor.grey200?.cgColor
        $0.layer.borderWidth = 1
        
        $0.layer.shadowColor = UIColor.grey200?.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 0.3)
        $0.layer.shadowRadius = 5
        $0.layer.shadowOpacity = 0.75
    }
    
    private lazy var postImage = UIImageView().then {
        $0.backgroundColor = .grey300
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 2.4
        $0.clipsToBounds = true
    }
    
    private lazy var postTitle = UILabel().then {
        $0.text = "게시글 제목"
        $0.textColor = .grey800
        $0.font = .ptdRegularFont(ofSize: 17)
    }
    
    private lazy var inProgress = UILabel().then {
        $0.text = "진행 중"
        $0.textColor = .grey700
        $0.font = .ptdSemiBoldFont(ofSize: 13)
    }
    
    private lazy var confirmBtn = UIButton().then {
        $0.backgroundColor = .dmrBlue
        $0.setTitle("동행 확정", for: .normal)
        $0.setTitleColor(.grey100, for: .normal)
        $0.titleLabel?.font = .ptdSemiBoldFont(ofSize: 13)
        $0.layer.cornerRadius = 5
        $0.isHidden = true
    }
    
    private func setupView() {
        addSubview(main)
        
        [
            postImage,
            postTitle,
            inProgress,
            confirmBtn,
        ].forEach {
            main.addSubview($0)
        }
        
        main.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(72)
        }
        
        postImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-12)
            $0.width.height.equalTo(48)
        }
        
        postTitle.snp.makeConstraints {
            $0.top.equalTo(postImage.snp.top).offset(3)
            $0.leading.equalTo(postImage.snp.trailing).offset(8)
        }
        
        inProgress.snp.makeConstraints {
            $0.bottom.equalTo(postImage.snp.bottom).offset(-3)
            $0.leading.equalTo(postTitle.snp.leading)
        }
        
        confirmBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-17)
            $0.width.equalTo(65)
            $0.height.equalTo(30)
        }
    }
}
