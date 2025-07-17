//
//  ProfileImageCell.swift
//  Duckmelang
//
//  Created by 주민영 on 2/5/25.
//

import UIKit

class ProfileImageCell: UITableViewCell {
    static let identifier = "ProfileImageCell"
    
    private var isLocked: Bool = true
    private var imageId: Int? // 서버에 보낼 image 아이디
    
    var lockToggleHandler: ((Bool, Int) -> Void)? // 상태 전달 클로저
    
    @objc
    private func lockBtnTapped() {
        print("버튼 탭")
        guard let imageId = self.imageId else { return }
        isLocked.toggle()
        updateLockButton()
        
        lockToggleHandler?(isLocked, imageId)
    }
    
    private func updateLockButton() {
        let imageName = isLocked ? "lock" : "unLock"
        lockBtn.setImage(UIImage(named: imageName), for: .normal)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        self.userImage.layer.cornerRadius = self.userImage.frame.width / 2
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        lockBtn.addTarget(self, action: #selector(lockBtnTapped), for: .touchUpInside)
        self.selectionStyle = .none
        self.setView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.userImage.image = nil
        self.userName.text = nil
        self.uploadDate.text = nil
        self.largeUserImage.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let headerView = UIView().then {
        $0.backgroundColor = .white
        $0.isUserInteractionEnabled = true
        $0.clipsToBounds = false
    }
    
    let userImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .grey200
        $0.contentMode = .scaleAspectFill
    }
    
    let userName = UILabel().then {
        $0.font = .ptdRegularFont(ofSize: 12)
        $0.textColor = .grey800
        $0.textAlignment = .left
    }
    
    let uploadDate = UILabel().then {
        $0.font = .ptdRegularFont(ofSize: 12)
        $0.textColor = .grey500
        $0.textAlignment = .left
    }
    
    let largeUserImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.backgroundColor = .grey200
        $0.contentMode = .scaleAspectFill
    }
    
    let footerView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let lockBtn = UIButton().then {
        $0.setImage(UIImage(named: "lock"), for: .normal)
    }
    
    private func setView() {
        contentView.addSubview(headerView)
        contentView.addSubview(largeUserImage)
        contentView.addSubview(footerView)
        
        [
            userImage,
            userName,
            uploadDate,
            lockBtn
        ].forEach {
            headerView.addSubview($0)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        largeUserImage.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(largeUserImage.snp.width)
        }
        
        footerView.snp.makeConstraints {
            $0.top.equalTo(largeUserImage.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(12)
        }
        
        userImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(32)
        }
        
        userName.snp.makeConstraints {
            $0.top.equalTo(userImage.snp.top).offset(1)
            $0.leading.equalTo(userImage.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        uploadDate.snp.makeConstraints {
            $0.bottom.equalTo(userImage.snp.bottom).offset(-1)
            $0.leading.equalTo(userName.snp.leading)
        }
        
        
        lockBtn.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.height.width.equalTo(24)
        }
    }
    
    public func configure(profileData: OtherProfileData, model: OtherImageData) {
        if let lastestUserImageUrl = URL(string: profileData.latestPublicMemberProfileImage) {
            self.userImage.kf.setImage(
                with: lastestUserImageUrl,
                placeholder: UIImage()
            )
        }
        
        if let userImageUrl = URL(string: model.memberProfileImageUrl) {
            self.largeUserImage.kf.setImage(
                with: userImageUrl,
                placeholder: UIImage()
            )
        }
        
        self.userName.text = "\(profileData.nickname) 님의 프로필 사진"
        self.uploadDate.text = formatDate(model.createdAt)
    }
    
    public func configure(profileData: myPageResponse, model: ProfileImageData, handler: @escaping (Bool, Int) -> Void) {
        self.lockToggleHandler = nil
        self.imageId = model.memberProfileImageId
        self.isLocked = model.publicStatus
        updateLockButton()

        if let lastestUserImageUrl = URL(string: profileData.latestPublicMemberProfileImage) {
            self.userImage.kf.setImage(
                with: lastestUserImageUrl,
                placeholder: UIImage()
            )
        }
        
        if let userImageUrl = URL(string: model.memberProfileImageUrl) {
            self.largeUserImage.kf.setImage(
                with: userImageUrl,
                placeholder: UIImage()
            )
        }
        
        self.userName.text = "나의 프로필 사진"
        self.uploadDate.text = formatDate(model.createdAt)
        self.lockToggleHandler = handler
    }
    
    private func formatDate(_ isoDateString: String) -> String {
        var formattedDate: String = ""
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        inputFormatter.locale = Locale(identifier: "ko_KR")

        if let date = inputFormatter.date(from: isoDateString) {
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: Date()) // 현재 연도
            let dateYear = calendar.component(.year, from: date) // 입력된 날짜의 연도

            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "ko_KR")
            
            // 현재 연도와 다르면 연도를 포함, 같으면 연도 제외
            if currentYear == dateYear {
                outputFormatter.dateFormat = "MM월 dd일"
            } else {
                outputFormatter.dateFormat = "yyyy년 MM월 dd일"
            }

            formattedDate = outputFormatter.string(from: date)
        } else {
            formattedDate = "날짜 없음"
        }
        
        return formattedDate
    }
}
