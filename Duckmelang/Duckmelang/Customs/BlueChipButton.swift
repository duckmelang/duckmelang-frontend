//
//  BlueChipButton.swift
//  Duckmelang
//
//  Created by 주민영 on 5/10/25.
//

import UIKit

class BlueChipButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    init(title: String, tag: Int) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        self.tag = tag
        setupStyle()
        
        self.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            updateStyle()
        }
    }
    
    private func setupStyle() {
        layer.cornerRadius = 15
        layer.borderWidth = 1
        layer.borderColor = UIColor.grey400?.cgColor
        titleLabel?.font = UIFont.ptdBoldFont(ofSize: 14)
        setTitleColor(.grey400, for: .selected)
        backgroundColor = .white
        updateStyle()
    }
    
    private func updateStyle() {
        if isSelected {
            backgroundColor = .dmrBlue
            setTitleColor(.grey0, for: .normal)
            layer.borderWidth = 0
        } else {
            backgroundColor = .white
            setTitleColor(.grey400, for: .normal)
            layer.borderWidth = 1
        }
    }
}
