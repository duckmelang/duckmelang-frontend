//
//  LandMineCollectionViewCell.swift
//  Duckmelang
//
//  Created by 김연우 on 1/28/25.
//

import UIKit
import SnapKit
import Then

class KeywordCell: UICollectionViewCell {
    static let identifier = "KeywordCell"
    
    private let keywordLabel = UILabel().then {
        $0.font = UIFont.ptdMediumFont(ofSize: 13)
        $0.textColor = .grey800
        $0.layer.masksToBounds = true
        $0.textAlignment = .center
    }
    
    private let deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "filterDelete"), for: .normal)
    }
    
    var deleteAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.grey500!.cgColor
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(keywordLabel)
        contentView.addSubview(deleteButton)
        
        keywordLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.leading.equalToSuperview().offset(14)
            $0.bottom.equalToSuperview().offset(-6)
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(keywordLabel)
            $0.leading.equalTo(keywordLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-14)
            $0.width.height.equalTo(12)
        }
    }
    
    func configure(with keyword: String) {
        keywordLabel.text = keyword
    }
    
    @objc private func deleteButtonTapped() {
        deleteAction?()
    }
}

