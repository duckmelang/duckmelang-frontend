//
//  MyMessageCell.swift
//  Duckmelang
//
//  Created by 주민영 on 1/23/25.
//

import UIKit

class MyMessageCell: UICollectionViewCell {
    static let identifier = "MyMessageCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var date = UILabel().then {
        $0.font = .ptdRegularFont(ofSize: 10)
        $0.textColor = .grey600
        $0.numberOfLines = 1
        $0.textAlignment = .right
    }
    
    private lazy var messageBox = UITextView().then {
        $0.textColor = .grey800
        $0.textAlignment = .right
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
            messageBox,
            date,
        ].forEach {
            contentView.addSubview($0)
        }

        messageBox.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-12)
            $0.width.lessThanOrEqualTo(200)
            $0.height.greaterThanOrEqualTo(25)
        }
        
        date.snp.makeConstraints {
            $0.bottom.equalTo(messageBox.snp.bottom)
            $0.trailing.equalTo(messageBox.snp.leading).offset(-6)
        }
    }
    
    func configure(text: String, date: String) {
        self.messageBox.text = text
        self.date.text = date
    }
}
