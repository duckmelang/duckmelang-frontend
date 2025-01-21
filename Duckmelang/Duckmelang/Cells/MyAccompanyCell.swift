//
//  MyAccompanyCell.swift
//  Duckmelang
//
//  Created by 주민영 on 1/14/25.
//

import UIKit

class MyAccompanyCell: UITableViewCell {
    static let identifier = "MyAccompanyCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        self.userImage.layer.cornerRadius = self.userImage.frame.width / 2
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16))
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
        self.postTitle.text = nil
        self.status.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let userImage = UIImageView().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grey500?.cgColor
        $0.clipsToBounds = true
        $0.backgroundColor = .grey300
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
        $0.textColor = .grey900
        $0.textAlignment = .left
    }
    
    let sentTime = UILabel().then {
        $0.font = .ptdRegularFont(ofSize: 12)
        $0.textColor = .grey500
        $0.textAlignment = .left
    }
    
    let postTitle = UILabel().then {
        $0.font = .ptdRegularFont(ofSize: 15)
        $0.textColor = .grey800
        $0.textAlignment = .left
        $0.numberOfLines = 2
    }
    
    let status = UILabel().then {
        $0.font = .ptdSemiBoldFont(ofSize: 14)
        $0.textColor = .dmrBlue
        $0.textAlignment = .center
    }
    
    let acceptBtn = UIButton().then {
        $0.setTitle("수락", for: .normal)
        $0.titleLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 14)
        $0.backgroundColor = .dmrBlue
        $0.setTitleColor(.grey0, for: .normal)
        $0.layer.cornerRadius = 15
        $0.addTarget(self, action: #selector(acceptBtnTapped), for: .touchUpInside)
    }
    
    // TODO: delegate로 구현
    @objc private func acceptBtnTapped() {
        print("수락")
    }
    
    let rejectBtn = UIButton().then {
        $0.setTitle("거절", for: .normal)
        $0.titleLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 14)
        $0.backgroundColor = .white
        $0.setTitleColor(.dmrBlue, for: .normal)
        $0.layer.cornerRadius = 15
        $0.addTarget(self, action: #selector(rejectBtnTapped), for: .touchUpInside)
    }
    
    // TODO: delegate로 구현
    @objc private func rejectBtnTapped() {
        print("거절")
    }
    
    let btnStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = 8
    }
    
    private func setView() {
        [
            postImage,
            userImage,
            userName,
            sentTime,
            postTitle,
            btnStackView,
            status
        ].forEach {
            contentView.addSubview($0)
        }
        
        btnStackView.addArrangedSubview(rejectBtn)
        btnStackView.addArrangedSubview(acceptBtn)
        
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
            $0.top.equalToSuperview().offset(1.5)
            $0.leading.equalTo(postImage.snp.trailing).offset(16)
        }
        
        sentTime.snp.makeConstraints {
            $0.top.equalToSuperview().offset(3.5)
            $0.leading.equalTo(userName.snp.trailing).offset(6)
        }
        
        postTitle.snp.makeConstraints {
            $0.top.equalTo(userName.snp.bottom).offset(6)
            $0.leading.equalTo(userName.snp.leading)
            $0.width.equalTo(200)
        }
        
        rejectBtn.snp.makeConstraints {
            $0.width.equalTo(49)
            $0.height.equalTo(28)
        }
        
        acceptBtn.snp.makeConstraints {
            $0.width.equalTo(49)
            $0.height.equalTo(28)
        }
        
        btnStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(4)
            $0.trailing.equalToSuperview()
        }
        
        status.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(4)
            $0.trailing.equalToSuperview().offset(-12)
        }
    }
    
    public func configure(model: MyAccompanyModel) {
        self.userImage.image = model.userImage
        self.postImage.image = model.postImage
        self.userName.text = model.userName
        self.sentTime.text = model.sentTime
        self.postTitle.text = model.postTitle
        
        updateStatus(model: model)
        updateViewVisibility(model: model)
    }

    private func updateStatus(model: MyAccompanyModel) {
        var statusText = ""

        switch model.status {
        case .accepted:
            statusText = "수락"
            self.status.textColor = .dmrBlue
        case .awaiting:
            statusText = "수락 대기중"
            self.status.textColor = .grey600
            self.status.text = statusText
            return
        case .rejected:
            statusText = "거절"
            self.status.textColor = .errorPrimary
        }

        switch model.requestType {
        case .sent:
            statusText += "됨"
        case .received:
            statusText += "함"
        default:
            break
        }

        self.status.text = statusText
    }

    private func updateViewVisibility(model: MyAccompanyModel) {
        switch (model.status, model.requestType) {
        case (.awaiting, _):
            self.btnStackView.isHidden = true
            self.status.isHidden = false
        case (_, .awaiting):
            self.btnStackView.isHidden = false
            self.status.isHidden = true
        default:
            self.btnStackView.isHidden = true
            self.status.isHidden = false
        }
    }

}
