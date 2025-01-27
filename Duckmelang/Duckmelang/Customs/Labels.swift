//
//  Labels.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class Label: UILabel {
    init(text: String?, font: UIFont, color: UIColor?){
        super.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = color
        self.textAlignment = .center
        self.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class paddingLabel: UILabel {
    init(text: String?, font: UIFont, color: UIColor?){
        super.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = color
        //self.textAlignment = .center
        self.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right, height: size.height + textInsets.top + textInsets.bottom)
    }
}
