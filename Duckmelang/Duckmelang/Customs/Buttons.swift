//
//  Buttons.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/27/25.
//

import UIKit

class myPageBtn: UIButton {
    init(text: String?){
        super.init(frame: .zero)
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString(text!, attributes: AttributeContainer([.font: UIFont.ptdRegularFont(ofSize: 16), .foregroundColor: UIColor.grey800!]))
        self.configuration = config
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomToggleButton: UIButton {
    
    private var isOn: Bool = false
    
    // ON/OFF 상태에 따라 사용할 이미지
    private let onImage = UIImage(resource: .toggle2) // ✅ ON 상태 이미지
    private let offImage = UIImage(resource: .toggle1) // ✅ OFF 상태 이미지
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        self.setImage(offImage, for: .normal) // 초기 상태 OFF
        self.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
    }
    
    @objc private func toggleButtonTapped() {
        isOn.toggle() // 상태 변경
        let newImage = isOn ? onImage : offImage
        self.setImage(newImage, for: .normal) // 이미지 변경
    }
    
    // 외부에서 상태를 변경할 수 있도록 설정
    func setToggleState(isOn: Bool) {
        self.isOn = isOn
        self.setImage(isOn ? onImage : offImage, for: .normal)
    }
}
