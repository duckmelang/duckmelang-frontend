//
//  LoginView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/14/25.
//

import UIKit
import SnapKit
import Then

class LoginView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인화면입니다"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.aritaBoldFont(ofSize: 18)
        return label
    }()
    
    
    // MARK: - Setup Methods
    
    private func setupView() {
        backgroundColor = .white
        addSubviews(titleLabel)
        setupConstraints()
    }
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview() // 부모 뷰의 중앙에 배치
        }
    }
}
    
// MARK: - UIView Extension

private extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}

