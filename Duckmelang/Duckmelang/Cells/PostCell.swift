//
//  PostCell.swift
//  Duckmelang
//
//  Created by 고현낭 on 1/19/25.
//


import UIKit

class PostCell: UITableViewCell {
    static let identifier = "PostCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        self.userImage.layer.cornerRadius = self.userImage.frame.width / 2
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16))
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.postImage.image = nil
        self.postTitle.text = nil
        self.EventTypeDate.text = nil
        self.userImage.image = nil
        self.userName.text = nil
        self.postTime.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let postImage = UIImageView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grey300?.cgColor
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.backgroundColor = .grey200
    }
    
    let postTitle = UILabel().then {
        $0.font = .ptdRegularFont(ofSize: 16)
        $0.textColor = .grey900
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    let EventTypeDate = UILabel().then {
        $0.font = .ptdRegularFont(ofSize: 12)
        $0.textColor = .grey600
        $0.textAlignment = .left
    }
    
    let userImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .grey200
    }
    
    let userName = UILabel().then {
        $0.font = .ptdRegularFont(ofSize: 12)
        $0.textColor = .grey600
        $0.textAlignment = .left
    }
    
    let postTime = UILabel().then {
        $0.font = .ptdRegularFont(ofSize: 12)
        $0.textColor = .grey500
        $0.textAlignment = .right
    }
    
    private func setView() {
        [
            postImage,
            postTitle,
            EventTypeDate,
            userImage,
            userName,
            postTime,
        ].forEach {
            contentView.addSubview($0)
        }
        
        postImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.height.equalTo(94)
        }
        
        postTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalTo(postImage.snp.trailing).offset(12)
        }
        
        EventTypeDate.snp.makeConstraints {
            $0.top.equalTo(postTitle.snp.bottom).offset(6)
            $0.leading.equalTo(postTitle.snp.leading)
        }
        
        userImage.snp.makeConstraints {
            $0.leading.equalTo(postTitle.snp.leading)
            $0.bottom.equalToSuperview().offset(-7)
            $0.width.height.equalTo(16)
        }
        
        userName.snp.makeConstraints {
            $0.centerY.equalTo(userImage.snp.centerY)
            $0.leading.equalTo(userImage.snp.trailing).offset(6)
        }
        
        postTime.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
        }
    }
    
    public func configure(model: PostModel) {
        self.postImage.image = model.postImage
        self.postTitle.text = model.postTitle
        self.EventTypeDate.text = "\(model.EventType) | \(model.EventDate)"
        self.userImage.image = model.userImage
        self.userName.text = model.userName
        self.postTime.text = model.postTime
    }
}

