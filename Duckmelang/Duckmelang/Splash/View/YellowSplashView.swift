//
//  SplashView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/14/25.
//

import UIKit
import SnapKit
import Then

class YellowSplashView: UIView {

    // 로고 이미지 뷰 정의
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "logo_white") // Assets에 있는 이미지 이름
        $0.contentMode = .scaleAspectFit
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        // 배경색 설정
        backgroundColor = .mainColor

        // 로고 이미지 뷰를 추가하면서 SnapKit을 이용한 제약조건을 설정
        addSubview(logoImageView)

        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview() // 부모 뷰의 중심에 배치
            $0.width.height.equalTo(75) // 너비와 높이를 각각 75pt로 설정
        }
    }
}
