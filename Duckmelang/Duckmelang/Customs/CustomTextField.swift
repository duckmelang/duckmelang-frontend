//
//  CustomTextField.swift
//  Duckmelang
//
//  Created by 주민영 on 6/28/25.
//

import UIKit

enum TextFieldState {
    case normal
    case editing
    case error
}

class CustomTextField: UITextField {
    
    // MARK: - Properties
    private var currentState: TextFieldState = .normal {
        didSet {
            updateTextColor()
        }
    }
    
    var isInErrorState: Bool {
        return currentState == .error
    }

    // MARK: - Initializer
    init(placeholder: String, keyboardType: UIKeyboardType = .default) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        setupStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }

    // MARK: - Setup
    private func setupStyle() {
        // 텍스트 스타일
        self.font = UIFont.ptdRegularFont(ofSize: 15)
        self.textColor = UIColor.black

        // 왼쪽 패딩
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        self.leftView = leftPaddingView
        self.leftViewMode = .always

        // 테두리
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.grey400?.cgColor

        // 사용자 입력 설정
        self.isUserInteractionEnabled = true
        self.returnKeyType = .done
        self.autocapitalizationType = .none

        // 상태 감지
        addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        
        // 높이 고정
        self.snp.makeConstraints {
            $0.height.equalTo(40)
        }
    }

    // MARK: - 상태
    @objc private func editingDidBegin() {
        currentState = .editing
    }

    @objc private func editingDidEnd() {
        currentState = .normal
    }
    
    func setErrorState(_ isError: Bool) {
        currentState = isError ? .error : (isFirstResponder ? .editing : .normal)
    }

    private func updateTextColor() {
        switch currentState {
        case .normal:
            self.textColor = UIColor.black
            self.layer.borderColor = UIColor.grey400?.cgColor
        case .editing:
            self.textColor = UIColor.dmrBlue
            self.layer.borderColor = UIColor.dmrBlue?.cgColor
        case .error:
            self.textColor = UIColor.errorPrimary
            self.layer.borderColor = UIColor.errorPrimary?.cgColor
        }
    }
}
