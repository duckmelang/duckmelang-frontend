//
//  TextFields.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/24/25.
//

import UIKit

class TextField: UITextField {
    func configTextField(placeholder: String?, leftView: UIView, leftViewMode: UITextField.ViewMode, interaction: Bool?) {
        self.placeholder = placeholder
        self.leftView = leftView
        self.leftViewMode = leftViewMode
        self.isUserInteractionEnabled = interaction!
    }
    
    func configLabel(text: String?, font: UIFont?, color: UIColor) {
        self.text = text
        self.font = font
        self.textColor = color
    }
    
    func configLayer(layerBorderWidth: CGFloat? = 0, layerCornerRadius: CGFloat?, layerColor: UIColor?) {
        self.layer.borderWidth = layerBorderWidth!
        self.layer.cornerRadius = layerCornerRadius!
        self.layer.borderColor = layerColor?.cgColor
    }
}
