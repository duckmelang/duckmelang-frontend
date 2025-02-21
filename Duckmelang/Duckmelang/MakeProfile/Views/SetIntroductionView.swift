//
//  SetIntroductionView.swift
//  Duckmelang
//
//  Created by 김연우 on 2/21/25.
//

import UIKit

class SetIntroductionView: UIView, UITextFieldDelegate {
    
    weak var delegate: SetIntroductionViewDelegate?
    
    private let titleLabel = UILabel().then {
        $0.text = "자기소개를 적어주세요!"
        $0.font = UIFont.aritaBoldFont(ofSize: 20)
        $0.textColor = .grey800
    }
    private lazy var introductionLabel = Label(text: "자기소개", font: .ptdMediumFont(ofSize: 15), color: .grey700)
    
    lazy var introductionTextField = TextField().then {
        $0.configLabel(text: "", font: .ptdMediumFont(ofSize: 15), color: .grey600!)
        $0.configLayer(layerBorderWidth: 1, layerCornerRadius: 5, layerColor: .grey400)
        $0.configTextField(placeholder: "자기소개를 입력해주세요", leftView: UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0)), leftViewMode: .always, interaction: true)
        $0.returnKeyType = .done
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupView()
        
        introductionTextField.delegate = self
        introductionTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        print("📌 텍스트 변경 감지 - 현재 입력값: '\(text)'") // ✅ 디버깅 로그
        delegate?.introductionTextDidChange(text) // ✅ VC에 값 전달
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        print("📌 return 키 눌림 - 현재 입력값: \(textField.text ?? "없음")") // ✅ 로그 추가
        textField.resignFirstResponder() // ✅ 키보드 닫기
        delegate?.introductionTextDidChange(text)
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [
            titleLabel,
            introductionLabel,
            introductionTextField
        ].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview()
        }
        
        introductionLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        introductionTextField.snp.makeConstraints{
            $0.top.equalTo(introductionLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
    }
}

protocol SetIntroductionViewDelegate: AnyObject {
    func introductionTextDidChange(_ text: String)
}
