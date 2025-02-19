//
//  BottomMessageView.swift
//  Duckmelang
//
//  Created by 주민영 on 1/27/25.
//

import UIKit

class BottomMessageView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var main = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var underline = UIView().then {
        $0.backgroundColor = UIColor.grey200
    }
    
    let messageTextField = UITextField().then {
        $0.placeholder = "메시지 보내기"
        $0.font = .ptdRegularFont(ofSize: 15)
        $0.borderStyle = .none
        $0.backgroundColor = .grey200
        $0.textColor = .black
        $0.layer.cornerRadius = 20
        
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 30, height: 0.0))
        $0.leftViewMode = .always
        $0.rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 30, height: 0.0))
        $0.rightViewMode = .always
    }
    
    let sendBtn = UIButton().then {
        $0.setImage(UIImage(named: "Send"), for: .normal)
    }
    
    private func setupView() {
        addSubview(main)
        
        [
            underline,
            messageTextField,
        ].forEach {
            main.addSubview($0)
        }
        
        main.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        underline.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func setupIncompleteView() {
        main.addSubview(sendBtn)
        
        messageTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-48)
            $0.bottom.equalToSuperview().offset(-12)
        }
        
        sendBtn.snp.makeConstraints {
            $0.centerY.equalTo(messageTextField.snp.centerY)
            $0.leading.equalTo(messageTextField.snp.trailing).offset(8)
            $0.width.height.equalTo(24)
        }
    }
    
    func setupCompleteView() {
        messageTextField.isEnabled = false
        messageTextField.isUserInteractionEnabled = false
        messageTextField.text = "메시지를 보낼 수 없습니다."
        messageTextField.textColor = .grey100
        messageTextField.backgroundColor = .grey400
        
        messageTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-12)
            $0.width.greaterThanOrEqualTo(343)
        }
    }
}
