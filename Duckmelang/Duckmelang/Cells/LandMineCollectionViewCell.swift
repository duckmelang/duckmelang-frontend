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
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .white
        $0.backgroundColor = .grey800
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.textAlignment = .center
    }
    
    private let deleteButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        $0.tintColor = .white
    }
    
    var deleteAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(keywordLabel)
        contentView.addSubview(deleteButton)
        
        keywordLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(4)
            $0.size.equalTo(20)
        }
    }
    
    func configure(with keyword: String) {
        keywordLabel.text = keyword
    }
    
    @objc private func deleteButtonTapped() {
        deleteAction?()
    }
}

