//
//  BlueSplashView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/14/25.
//

import UIKit
import SnapKit
import Then

class BlueSplashView: UIView {
    init(title: String, subTitle: String) {
        super.init(frame: .zero)
        
        self.titleView.text = title
        self.subTitleView.text = subTitle
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 타이틀
    private let titleView = UILabel().then {
        $0.font = .aritaBoldFont(ofSize: 24)
        $0.textColor = .grey0
    }

    // 서브타이틀
    private let subTitleView = UILabel().then {
        $0.font = .aritaMediumFont(ofSize: 15)
        $0.textColor = .grey100
    }
    
    private var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = 9
    }

    private func setupView() {
        backgroundColor = .dmrBlue
        
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(subTitleView)
        addSubview(stackView)

        stackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
