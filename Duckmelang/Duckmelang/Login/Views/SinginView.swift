//
//  navigateToIDPWView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/25/25.
//

import UIKit
import Then
import SnapKit

class SinginView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        [
        ].forEach {
            addSubview($0)
        }
    }
}
