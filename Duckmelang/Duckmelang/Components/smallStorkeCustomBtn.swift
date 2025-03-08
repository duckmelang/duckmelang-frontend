//
//  smallStorkeCustomBtn.swift
//  Duckmelang
//
//  Created by 주민영 on 1/18/25.
//

// 짧은 커스텀 버튼

import UIKit
import SnapKit

class smallStorkeCustomBtn: UIButton {
    /// 버튼 활성화 상태에서의 기본 배경색
    private var originalStrokeColor: UIColor = .dmrBlue!
    
    /// 버튼 테두리 색상 (setter 추가)
    var borderColor: UIColor? {
        didSet {
            self.layer.borderColor = borderColor?.cgColor
        }
    }
    
    /// 버튼 타이틀 색상
    var titleColor: UIColor? {
            didSet {
                self.setTitleColor(titleColor, for: .normal)
            }
        }
    
    // MARK: - Initializer
    init(
        borderColor: CGColor = UIColor.dmrBlue?.cgColor ?? UIColor.systemBlue.cgColor,
        title: String = "",
        titleColor: UIColor = UIColor.dmrBlue ?? UIColor.systemBlue,
        font: UIFont? = nil,
        radius: CGFloat? = nil,
        isEnabled: Bool? = nil,
        width: CGFloat = 140,
        height: CGFloat = 44
    ) {
        super.init(frame: .zero)
        configureButton(
            title: title,
            titleColor: titleColor,
            font: font ?? .ptdSemiBoldFont(ofSize: 14),
            radius: radius ?? 23,
            borderColor: borderColor,
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
        borderColor: CGColor,
        isEnabled: Bool?,
        width: CGFloat,
        height: CGFloat
    ) {
        configureButton(
            title: title,
            titleColor: titleColor,
            font: font,
            radius: radius ?? 23,
            borderColor: borderColor,
            isEnabled: isEnabled ?? true
        )
        
        self.snp.makeConstraints {
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }
    }
    
    /// 버튼 활성화 상태 업데이트
    func setEnabled(_ isEnabled: Bool?) {
        self.isEnabled = isEnabled ?? true
        updateBackgroundColor()
    }
    
    // MARK: - Private Helper Methods
    private func configureButton(
        title: String,
        titleColor: UIColor,
        font: UIFont,
        radius: CGFloat,
        borderColor: CGColor,
        isEnabled: Bool
    ) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        self.layer.cornerRadius = radius
        self.layer.borderColor = borderColor
        self.layer.borderWidth = 1
        self.isEnabled = isEnabled
        updateBackgroundColor()
    }
    
    private func updateBackgroundColor() {
        self.setTitleColor(self.isEnabled ? UIColor.dmrBlue! : UIColor.grey400!, for: .normal)
        self.layer.borderColor = self.isEnabled ? UIColor.dmrBlue!.cgColor : UIColor.grey400!.cgColor
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
//let btn = smallStorkeCustomBtn(title: "활성화")
//
////다른 속성들도 설정할 때
//let button = smallStorkeCustomBtn(
//    backgroundColor: .red,
//    title: "취소",
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


