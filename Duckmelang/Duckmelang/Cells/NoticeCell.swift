//
//  NoticeCell.swift
//  Duckmelang
//
//  Created by 김연우 on 2/1/25.
//

import UIKit
import SnapKit
import Then

class NoticeCell: UITableViewCell {
    
    static let identifier = "NoticeCell"
    
    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.masksToBounds = true
    }
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.backgroundColor = .grey300 // FIXME: - 실제 이미지 로드 필요
    }
    
    private let noticeLabel = UILabel().then {
        $0.font = UIFont.ptdRegularFont(ofSize: 15)
        $0.textColor = .grey900
    }
    
    private let timeLabel = UILabel().then {
        $0.font = UIFont.ptdRegularFont(ofSize: 12)
        $0.textColor = .grey500
    }
    
    private let newBadge = UIImageView().then {
        $0.image = UIImage(named: "noticeLabel")
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true // 기본적으로 숨김
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(containerView)
        [
            profileImageView,
            noticeLabel,
            timeLabel,
            newBadge
        ].forEach {
            containerView.addSubview($0)
        }
        
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(55)
        }
        
        noticeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().offset(-55)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(noticeLabel.snp.bottom).offset(7)
            $0.leading.equalTo(noticeLabel.snp.leading)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        newBadge.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
    }
    
    func configure(with notice: NoticeModel, isNew: Bool) {
        noticeLabel.text = notice.noticeTitle
        timeLabel.text = notice.noticeTime
        newBadge.isHidden = !isNew
        profileImageView.image = notice.profile
        
        let alphaValue: CGFloat = isNew ? 1.0 : 0.6
            
        noticeLabel.alpha = alphaValue
        timeLabel.alpha = alphaValue
        profileImageView.alpha = alphaValue
        newBadge.alpha = alphaValue
    }
    
    func configure(with notice: NotificationModel) {
        noticeLabel.text = notice.content
        
        if let date = dateFromString(notice.createdAt) {
            self.timeLabel.text = timeAgo(from: date)
        } else {
            self.timeLabel.text = "날짜 없음"
        }
        
        newBadge.isHidden = notice.isRead
        
        if let extraDataUrl = URL(string: notice.extraData) {
            self.profileImageView.kf.setImage(with: extraDataUrl, placeholder: UIImage())
        }
        
        let alphaValue: CGFloat = !notice.isRead ? 1.0 : 0.6
            
        noticeLabel.alpha = alphaValue
        timeLabel.alpha = alphaValue
        profileImageView.alpha = alphaValue
        newBadge.alpha = alphaValue
    }
    
    func dateFromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: dateString)
    }
    
    func timeAgo(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents(
            [.year, .month, .weekOfYear, .day, .hour, .minute],
            from: date,
            to: now
        )

        if let year = components.year, year > 0 {
            return "\(year)년 전"
        }
        
        if let month = components.month, month > 0 {
            return "\(month)달 전"
        }
        
        if let week = components.weekOfYear, week > 0 {
            return "\(week)주 전"
        }
        
        if let day = components.day, day > 0 {
            return "\(day)일 전"
        }
        
        if let hour = components.hour, hour > 0 {
            return "\(hour)시간 전"
        }
        
        if let minute = components.minute, minute > 0 {
            return "\(minute)분 전"
        }
        
        return "방금 전"
    }
}
