//
//  FilterKeywordsView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/28/25.
//

import UIKit
import Then
import SnapKit

class FilterKeywordsView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.text = "피하고싶은 키워드를 알려주세요!"
        $0.font = UIFont.aritaBoldFont(ofSize: 20)
        $0.textColor = .grey800
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "해당 키워드가 포함된 게시글은 필터가 씌워져요."
        $0.font = UIFont.ptdRegularFont(ofSize: 13)
        $0.textColor = .grey600
    }
    
    private let filterKeywordTextField = UITextField().then {
        $0.placeholder = "텍스트 입력"
        $0.borderStyle = .roundedRect

        // 왼쪽 패딩 추가
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        $0.leftView = leftPaddingView
        $0.leftViewMode = .always

        // 돋보기 아이콘 추가 (오른쪽)
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .grey600
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        searchIcon.center = CGPoint(x: rightPaddingView.frame.width / 2, y: rightPaddingView.frame.height / 2)
        rightPaddingView.addSubview(searchIcon)

        $0.rightView = rightPaddingView
        $0.rightViewMode = .always
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [
            titleLabel,
            subtitleLabel,
            filterKeywordTextField
        ].forEach {
            addSubview($0)
        }
            
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview()
        }
            
        filterKeywordTextField.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
}
