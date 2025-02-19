//
//  MyAccompanyCell.swift
//  Duckmelang
//
//  Created by 주민영 on 1/14/25.
//

import UIKit

protocol MyAccompanyCellDelegate: AnyObject {
    func acceptBtnTapped(cell: MyAccompanyCell)
    func rejectBtnTapped(cell: MyAccompanyCell)
}

class MyAccompanyCell: UITableViewCell {
    weak var delegate: MyAccompanyCellDelegate?
    
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
        $0.numberOfLines = 1
    }
    
    let status = UILabel().then {
        $0.font = .ptdSemiBoldFont(ofSize: 14)
        $0.textColor = .dmrBlue
        $0.textAlignment = .center
        $0.isHidden = false
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
        delegate?.acceptBtnTapped(cell: self)
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
        delegate?.rejectBtnTapped(cell: self)
    }
    
    let btnStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = 8
        $0.isHidden = true
    }
    
    private func setView() {
        [
            userImage,
            postImage,
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
    
    public func configure(status: String, model: RequestDTO) {
        if let userImageUrl = URL(string: model.oppositeProfileImage) {
            self.userImage.kf.setImage(with: userImageUrl, placeholder: UIImage())
        }
        if let postImageUrl = URL(string: model.postImage) {
            self.postImage.kf.setImage(with: postImageUrl, placeholder: UIImage())
        }
        
        self.userName.text = model.oppositeNickname
        self.sentTime.text = formatDate(model.applicationCreatedAt)
        self.postTitle.text = model.postTitle
        
        updateStatus(status: status, applicationStatus: model.applicationStatus)
    }
    
    private func formatDate(_ isoDateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone.current
        
        if let date = dateFormatter.date(from: isoDateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.locale = Locale(identifier: "ko_KR")
            displayFormatter.dateFormat = "hh:mm"
            
            return displayFormatter.string(from: date)
        } else {
            return "시간 없음"
        }
    }
    
    private func updateStatus(status: String, applicationStatus: String) {
        var statusText = ""
        
        if (status == "PENDING") {
            self.btnStackView.isHidden = false
            self.status.isHidden = true
            return
        }
        
        if (applicationStatus == "PENDING") {
            statusText = "수락 대기중"
            self.status.textColor = .grey600
            self.status.text = statusText
            return
        }
        
        switch applicationStatus {
        case "SUCCEED":
            statusText = "수락"
            self.status.textColor = .dmrBlue
        case "FAILED":
            statusText = "거절"
            self.status.textColor = .errorPrimary
        default:
            break
        }
        
        switch status {
        case "SENT":
            statusText += "됨"
        case "RECEIVED":
            statusText += "함"
        default:
            break
        }

        self.status.text = statusText
        self.btnStackView.isHidden = true
        self.status.isHidden = false
    }
    
    public func updateForRequest() {
        self.btnStackView.isHidden = true
        self.status.isHidden = false
    }
}
