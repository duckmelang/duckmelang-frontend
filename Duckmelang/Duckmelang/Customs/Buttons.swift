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
