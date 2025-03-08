//
//  MessageHeaderCell.swift
//  Duckmelang
//
//  Created by 주민영 on 2/10/25.
//

import UIKit

class MessageHeaderCell: UICollectionReusableView {
    static let identifier = "MessageHeaderCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let dateLabel = UILabel().then {
        $0.font = UIFont.ptdRegularFont(ofSize: 12)
        $0.textColor = .grey600
        $0.textAlignment = .center
    }
    
    private func setupView() {
        addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    func configure(date: String) {
        dateLabel.text = date
    }
}
