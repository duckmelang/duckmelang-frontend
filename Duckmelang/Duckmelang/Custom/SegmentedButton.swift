//
//  SegmentedButton.swift
//  Duckmelang
//
//  Created by 주민영 on 1/14/25.
//

import UIKit

class SegmentedButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }
    
    init(title: String, width: Int, tag: Int) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        self.tag = tag
        setupStyle()
        
        self.snp.makeConstraints {
            $0.width.equalTo(width)
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
        layer.borderColor = UIColor.grey300?.cgColor
        titleLabel?.font = UIFont.ptdMediumFont(ofSize: 13)
        setTitleColor(.grey800, for: .normal)
        setTitleColor(.grey0, for: .selected)
        updateStyle()
    }
    
    private func updateStyle() {
        if isSelected {
            backgroundColor = .grey900
            setTitleColor(.grey0, for: .normal)
            layer.borderWidth = 0
        } else {
            backgroundColor = .white
            setTitleColor(.grey800, for: .normal)
            layer.borderWidth = 1
        }
    }
}
