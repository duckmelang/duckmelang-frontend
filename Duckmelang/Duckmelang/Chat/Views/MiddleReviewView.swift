//
//  MiddleReviewView.swift
//  Duckmelang
//
//  Created by 주민영 on 1/31/25.
//

import UIKit

class MiddleReviewView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateView(info: ReviewInformation) {
        if let userImageUrl = URL(string: info.latestPublicMemberProfileImage) {
            self.userImage.kf.setImage(with: userImageUrl, placeholder: UIImage())
        }
        if let postImageUrl = URL(string: info.postImageUrl) {
            self.postImage.kf.setImage(with: postImageUrl, placeholder: UIImage())
        }
        self.userName.text = info.name
        self.postTitle.text = info.title
        self.category.text = info.eventCategory
        self.date.text = info.date
    }
    
    let userImage = UIImageView().then {
        $0.image = UIImage()
        $0.clipsToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grey300?.cgColor
        $0.layer.cornerRadius = 36/2
        $0.backgroundColor = .grey200
    }
    
    let postImage = UIImageView().then {
        $0.image = UIImage()
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grey400?.cgColor
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.backgroundColor = .grey200
    }
    
    let userName = UILabel().then {
        $0.text = "지구젤리"
        $0.font = .ptdMediumFont(ofSize: 12)
        $0.textColor = .grey600
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    let postTitle = UILabel().then {
        $0.text = "에스파 앙콘 막콘 동행 구해요!"
        $0.font = .ptdRegularFont(ofSize: 12)
        $0.textColor = .grey700
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    let category = UILabel().then {
        $0.text = "콘서트"
        $0.font = .ptdRegularFont(ofSize: 11)
        $0.textColor = .grey600
        $0.textAlignment = .left
    }
    
    let divider = UILabel().then {
        $0.text = "|"
        $0.font = .ptdRegularFont(ofSize: 11)
        $0.textColor = .grey400
        $0.textAlignment = .left
    }
    
    let date = UILabel().then {
        $0.text = "3월 16일"
        $0.font = .ptdRegularFont(ofSize: 11)
        $0.textColor = .grey600
        $0.textAlignment = .left
    }
    
    private func setupView() {
        [
            userImage,
            postImage,
            userName,
            postTitle,
            category,
            divider,
            date
        ].forEach {
            addSubview($0)
        }
        
        userImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.height.equalTo(36)
        }
        
        postImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().offset(18)
            $0.width.height.equalTo(36)
        }
        
        userName.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalTo(postImage.snp.trailing).offset(16)
            $0.width.equalTo(50)
        }
        
        postTitle.snp.makeConstraints {
            $0.top.equalTo(userName.snp.top)
            $0.leading.equalTo(userName.snp.trailing).offset(6)
            $0.trailing.equalToSuperview().offset(-8)
        }
        
        category.snp.makeConstraints {
            $0.top.equalTo(userName.snp.bottom).offset(6)
            $0.leading.equalTo(userName.snp.leading)
            $0.width.equalTo(60)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(category.snp.top)
            $0.leading.equalTo(category.snp.trailing).offset(12)
        }
        
        date.snp.makeConstraints {
            $0.top.equalTo(category.snp.top)
            $0.leading.equalTo(divider.snp.trailing).offset(12)
            $0.width.equalTo(60)
        }
    }
}
