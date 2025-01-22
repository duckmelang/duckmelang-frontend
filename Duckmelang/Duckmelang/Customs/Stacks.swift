//
//  Stack.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class Stack : UIStackView {
    init(axis: NSLayoutConstraint.Axis, spacing: CGFloat = .zero, distribution: UIStackView.Distribution = .fill, alignment: UIStackView.Alignment = .leading){
        super.init(frame: .zero)
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = alignment
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
