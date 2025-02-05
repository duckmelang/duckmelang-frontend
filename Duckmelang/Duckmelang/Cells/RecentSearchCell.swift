//
//  RecentSearchCell.swift
//  Duckmelang
//
//  Created by 김연우 on 2/1/25.
//

import UIKit
import Then
import SnapKit

class RecentSearchCell: UITableViewCell {
    
    private let containerView = UIView().then {
        $0.backgroundColor = .clear
    }

    private let keywordLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    private let deleteButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = .gray
    }
    
    var deleteAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(containerView)
        containerView.addSubview(keywordLabel)
        containerView.addSubview(deleteButton)

        containerView.snp.makeConstraints {
            $0.width.equalTo(180)
            $0.right.equalToSuperview().offset(-20)
            $0.top.bottom.equalToSuperview().inset(4)
        }
        
        keywordLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(deleteButton.snp.leading).offset(-8)
            $0.top.bottom.equalToSuperview().inset(8) // 상하 패딩 추가
        }
        
        deleteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
    }
    
    private func setupActions() {
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func deleteButtonTapped() {
        deleteAction?()
    }
    
    func configure(with keyword: String, at index: Int, deleteAction: @escaping () -> Void) {
        keywordLabel.text = keyword
        self.deleteAction = deleteAction

        containerView.snp.remakeConstraints {
            $0.width.equalTo(180)
            if index == 0 {
                $0.left.equalToSuperview().offset(20) // 첫 번째 검색어 왼쪽 정렬
                deleteButton.isHidden = true // X 버튼 숨김
            } else {
                $0.right.equalToSuperview().offset(-20) // 나머지는 오른쪽 정렬
                deleteButton.isHidden = false
            }
            $0.top.bottom.equalToSuperview().inset(4)
        }
    }
}
