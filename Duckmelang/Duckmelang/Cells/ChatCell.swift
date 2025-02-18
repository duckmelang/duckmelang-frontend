//
//  ChatCell.swift
//  Duckmelang
//
//  Created by 주민영 on 1/16/25.
//

import UIKit

class ChatCell: UITableViewCell {
    static let identifier = "ChatCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        self.userImage.layer.cornerRadius = self.userImage.frame.width / 2
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.userImage.image = nil
        self.postImage.image = nil
        self.userName.text = nil
        self.sentTime.text = nil
        self.recentMessage.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let userImage = UIImageView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grey300?.cgColor
        $0.clipsToBounds = true
        $0.backgroundColor = .grey200
    }
    
    let postImage = UIImageView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grey400?.cgColor
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.backgroundColor = .grey300
    }
    
    let userName = UILabel().then {
        $0.font = .ptdRegularFont(ofSize: 15)
        $0.textColor = .grey800
        $0.textAlignment = .left
    }
    
    let sentTime = UILabel().then {
        $0.font = .ptdRegularFont(ofSize: 12)
        $0.textColor = .grey600
        $0.textAlignment = .left
    }
    
    let recentMessage = UILabel().then {
        $0.font = .ptdRegularFont(ofSize: 15)
        $0.textColor = .grey800
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    private func setView() {
        [
            userImage,
            postImage,
            userName,
            sentTime,
            recentMessage,
        ].forEach {
            contentView.addSubview($0)
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
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalTo(postImage.snp.trailing).offset(16)
        }
        
        sentTime.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalTo(userName.snp.trailing).offset(6)
        }
        
        recentMessage.snp.makeConstraints {
            $0.top.equalTo(userName.snp.bottom).offset(7)
            $0.leading.equalTo(userName.snp.leading)
            $0.trailing.equalToSuperview()
        }
    }
    
    public func configure(model: ChatModel) {
        self.userImage.image = model.userImage
        self.postImage.image = model.postImage
        self.userName.text = model.userName
        self.sentTime.text = model.sentTime
        self.recentMessage.text = model.recentMessage
        
        if (model.status == .done){
            contentView.alpha = 0.4
            self.recentMessage.text = "완료된 채팅"
        } else {
            contentView.alpha = 1
        }
    }
    
    public func configure(model: ChatDTO) {
        if let oppositeProfileImageUrl = URL(string: model.oppositeProfileImage) {
            self.userImage.kf.setImage(with: oppositeProfileImageUrl, placeholder: UIImage())
        }
        if let postImageUrl = URL(string: model.postImage) {
            self.postImage.kf.setImage(with: postImageUrl, placeholder: UIImage())
        }
        
        self.userName.text = model.oppositeNickname
        self.recentMessage.text = model.lastMessage

        // lastMessageTime 변환
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        inputFormatter.locale = Locale(identifier: "ko_KR")

        if let date = inputFormatter.date(from: model.lastMessageTime) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "a hh:mm"
            outputFormatter.locale = Locale(identifier: "ko_KR")
            
            let formattedString = outputFormatter.string(from: date)
            self.sentTime.text = formattedString
        }
        
        if (model.status == "TERMINEATED"){
            contentView.alpha = 0.4
            self.recentMessage.text = "완료된 채팅"
        } else {
            contentView.alpha = 1
        }
    }
}
