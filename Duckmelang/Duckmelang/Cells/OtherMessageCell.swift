//
//  OtherMessageCell.swift
//  Duckmelang
//
//  Created by 주민영 on 1/27/25.
//

import UIKit

protocol OtherMessageCellDelegate: AnyObject {
    func didTapUserImage(in cell: OtherMessageCell)
}

class OtherMessageCell: UICollectionViewCell {
    static let identifier = "OtherMessageCell"

    weak var delegate: OtherMessageCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupGesture()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userImageTapped))
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(tapGesture)
    }
    
    @objc private func userImageTapped() {
        delegate?.didTapUserImage(in: self)
    }
    
    private lazy var userImage = UIImageView().then {
        $0.backgroundColor = .grey200
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 32/2
    }
    
    private lazy var date = UILabel().then {
        $0.font = .ptdRegularFont(ofSize: 10)
        $0.textColor = .grey600
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    private lazy var messageBox = UITextView().then {
        $0.textColor = .grey800
        $0.textAlignment = .left
        $0.font = .ptdRegularFont(ofSize: 13)
        
        $0.layer.cornerRadius = 5
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grey300?.cgColor
        
        $0.backgroundColor = .white
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
    }
    
    private func setupView() {
        [
            userImage,
            messageBox,
            date,
        ].forEach {
            contentView.addSubview($0)
        }

        userImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-12)
            $0.width.height.equalTo(32)
        }

        messageBox.snp.makeConstraints {
            $0.top.equalTo(userImage.snp.top)
            $0.leading.equalTo(userImage.snp.trailing).offset(8)
            $0.width.lessThanOrEqualTo(200)
            $0.height.greaterThanOrEqualTo(25)
        }
        
        date.snp.makeConstraints {
            $0.bottom.equalTo(messageBox.snp.bottom)
            $0.leading.equalTo(messageBox.snp.trailing).offset(6)
        }
    }
    
    func configure(userImage: UIImage, text: String, date: String) {
        self.userImage.image = userImage
        self.messageBox.text = text
        self.date.text = date
    }
}
