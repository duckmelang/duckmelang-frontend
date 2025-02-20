//
//  longCustomBtn.swift
//  Duckmelang
//
//  Created by 주민영 on 1/18/25.
//

// 긴 커스텀 버튼

import UIKit
import SnapKit

class longCustomBtn: UIButton {
    /// 버튼 활성화 상태에서의 기본 배경색
    private var originalBackgroundColor: UIColor = .dmrBlue!
    
    // MARK: - Initializer
    init(
        backgroundColor: UIColor = UIColor.dmrBlue ?? .systemBlue,
        title: String = "",
        titleColor: UIColor = .white!,
        font: UIFont? = nil,
        radius: CGFloat? = nil,
        isEnabled: Bool? = nil,
        width: CGFloat = 343,
        height: CGFloat = 45
    ) {
        super.init(frame: .zero)
        configureButton(
            title: title,
            titleColor: titleColor,
            font: font ?? .ptdSemiBoldFont(ofSize: 17),
            radius: radius ?? 23,
            backgroundColor: backgroundColor,
            isEnabled: isEnabled ?? true
        )
        
        self.snp.makeConstraints {
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    /// 버튼 설정 업데이트
    func configure(
        title: String,
        titleColor: UIColor,
        font: UIFont,
        radius: CGFloat?,
        backgroundColor: UIColor,
        isEnabled: Bool?,
        width: CGFloat,
        height: CGFloat
    ) {
        configureButton(
            title: title,
            titleColor: titleColor,
            font: font,
            radius: radius ?? 23,
            backgroundColor: backgroundColor,
            isEnabled: isEnabled ?? true
        )
        
        self.snp.makeConstraints {
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }
    }
    
    /// 버튼 활성화 상태 업데이트
    func setEnabled(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
        updateBackgroundColor()
    }
    
    // MARK: - Private Helper Methods
    private func configureButton(
        title: String,
        titleColor: UIColor,
        font: UIFont,
        radius: CGFloat,
        backgroundColor: UIColor,
        isEnabled: Bool
    ) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        self.layer.cornerRadius = radius
        self.originalBackgroundColor = backgroundColor
        self.isEnabled = isEnabled
        updateBackgroundColor()
    }
    
    private func updateBackgroundColor() {
        self.backgroundColor = self.isEnabled ? originalBackgroundColor : .grey400
    }
    
    private func setDefaultHeight(_ height: CGFloat) {
        self.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
    }
}

// MARK: 버튼 사용 예시
//// 버튼 생성
////타이틀만 설정할 때
//let btn = longCustomBtn(title: "활성화")
//
////다른 속성들도 설정할 때
//let button = longCustomBtn(
//    backgroundColor: .red,
//    title: "다음",
//    titleColor: .white,
//    radius: 12,
//    isEnabled: true,
//    width: 343,
//    height: 43
//)
//
//// 버튼 구성 업데이트
//button.configure(
//    title: "취소",
//    titleColor: .red,
//    radius: nil,
//    backgroundColor: .systemGray,
//    isEnabled: false,
//    width: 343,
//    height: 43
//)
//
//// 활성화 상태 변경
//button.setEnabled(true)
