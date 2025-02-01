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
        $0.backgroundColor = .lightGray // FIXME: - 실제 이미지 로드 필요
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
    }
}
