//
//  NaviBar.swift
//  Duckmelang
//
//  Created by nau on 7/10/25.
//

import UIKit

final class CustomNavigationBar: UIView {
    
    private let leftButton: UIButton?
    private let rightButton: UIButton?
    
    private let titleLabel = UILabel().then {
        $0.font = .aritaSemiBoldFont(ofSize: 18)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    private let topStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalCentering
    }

    // 버튼 이미지 이름만 넘기면 자동으로 생성
    init(title: String, leftImageName: String? = nil, rightImageName: String? = nil) {
        if let leftImageName = leftImageName {
            let btn = UIButton()
            btn.setImage(UIImage(named: leftImageName), for: .normal)
            self.leftButton = btn
        } else {
            self.leftButton = nil
        }

        if let rightImageName = rightImageName {
            let btn = UIButton()
            btn.setImage(UIImage(named: rightImageName), for: .normal)
            self.rightButton = btn
        } else {
            self.rightButton = nil
        }

        super.init(frame: .zero)
        titleLabel.text = title
        setupView()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        if let left = leftButton {
            topStack.addArrangedSubview(left)
        } else {
            let placeholder = UIView()
            placeholder.snp.makeConstraints { $0.width.equalTo(24) }
            topStack.addArrangedSubview(placeholder)
        }

        topStack.addArrangedSubview(titleLabel)

        if let right = rightButton {
            topStack.addArrangedSubview(right)
        } else {
            let placeholder = UIView()
            placeholder.snp.makeConstraints { $0.width.equalTo(24) }
            topStack.addArrangedSubview(placeholder)
        }

        addSubview(topStack)
    }

    private func setupLayout() {
        topStack.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
    }

    // 버튼 액션 바인딩 제공
    func setLeftButtonAction(target: Any?, action: Selector) {
        leftButton?.addTarget(target, action: action, for: .touchUpInside)
    }

    func setRightButtonAction(target: Any?, action: Selector) {
        rightButton?.addTarget(target, action: action, for: .touchUpInside)
    }
}
