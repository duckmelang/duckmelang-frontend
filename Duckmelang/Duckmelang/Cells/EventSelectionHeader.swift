//
//  EventSelectionHeader.swift
//  Duckmelang
//
//  Created by 주민영 on 3/8/25.
//

import UIKit

class EventSelectionHeader: UICollectionReusableView {
    static let identifier = "EventSelectionHeader"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .ptdSemiBoldFont(ofSize: 17)
        $0.textColor = .grey800
    }

    func configure(text: String) {
        titleLabel.text = text
    }
}
