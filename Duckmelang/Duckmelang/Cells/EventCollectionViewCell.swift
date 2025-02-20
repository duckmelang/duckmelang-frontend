//
//  EventCollectionViewCell.swift
//  Duckmelang
//
//  Created by 김연우 on 2/20/25.
//

import UIKit
import Then
import SnapKit

class EventCollectionViewCell: UICollectionViewCell {
    static let identifier = "EventCollectionViewCell"
    
    
    
    public let button = UIButton().then {
        $0.titleLabel?.font = .ptdSemiBoldFont(ofSize: 14)
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        func configure(title: String, isSelected: Bool) {
            button.setTitle(title, for: .normal)
            button.setTitleColor(isSelected ? .white : .grey400, for: .normal)
            button.backgroundColor = isSelected ? .dmrBlue : .white
            button.layer.borderColor = isSelected ? UIColor.dmrBlue!.cgColor : UIColor.grey400!.cgColor
        }
    }
