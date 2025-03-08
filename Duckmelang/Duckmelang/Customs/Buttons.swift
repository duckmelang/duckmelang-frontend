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
    
    var isOn: Bool = false {
        didSet {
            updateImage()
        }
    }
    
    // ON/OFF 상태에 따라 사용할 이미지
    private let onImage = UIImage(named: "toggle2") // ✅ ON 상태 이미지
    private let offImage = UIImage(named: "toggle1") // ✅ OFF 상태 이미지
    
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
        updateImage()
        sendActions(for: .valueChanged) // ✅ 변경 이벤트 발생 (외부에서 감지 가능)
    }
    
    // 외부에서 상태를 변경할 수 있도록 설정
    func setToggleState(isOn: Bool) {
        self.isOn = isOn
        updateImage()
    }
    
    private func updateImage() {
        let newImage = isOn ? onImage : offImage
        self.setImage(newImage, for: .normal)
    }
}
