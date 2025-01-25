//
//  DateHeaderCell.swift
//  Duckmelang
//
//  Created by 주민영 on 1/23/25.
//

import UIKit

class DateHeaderCell: UICollectionViewCell {
    static let identifier = "DateHeaderCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let dateLabel = UILabel().then {
        $0.font = .ptdRegularFont(ofSize: 12)
        $0.textColor = .grey600
        $0.textAlignment = .center
    }

    func configure(with dateText: String) {
        dateLabel.text = dateText
        
        self.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
