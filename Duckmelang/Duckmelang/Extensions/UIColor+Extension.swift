//
//  UIColor+Extension.swift
//  Duckmelang
//
//  Created by 주민영 on 1/13/25.
//

import Foundation
import UIKit

extension UIColor {
    // HEX 문자열을 UIColor로 변환하는 초기화 메서드
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let length = hexSanitized.count

        let r, g, b, a: CGFloat
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            a = 1.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

// Example
// let buttonColor = UIColor(hex: "#314B9E")

extension UIColor {
    static let mainColor = UIColor(hex: "#FFD766")
    static let bgcPrimary = UIColor(hex: "#FCF7E8") // background container Primary
    static let bgcSecondary = UIColor(hex: "#F2B60D") // background container Secondary
    static let bgcThird = UIColor(hex: "#FDEAB4") // background container Third
    static let dmrBlue = UIColor(hex: "#4B4FBB")
    static let pressedBlue = UIColor(hex: "#474A85")
    static let errorPrimary = UIColor(hex: "#E75427")
    static let errorSecondary = UIColor(hex: "#F9D1B9")
    static let errorThird = UIColor(hex: "#A93609")
    
    static let grey900 = UIColor(hex: "#121211")
    static let grey800 = UIColor(hex: "#434240")
    static let grey700 = UIColor(hex: "#72716D")
    static let grey600 = UIColor(hex: "#9B9994")
    static let grey500 = UIColor(hex: "#BCB9B3")
    static let grey400 = UIColor(hex: "#D4D1CA")
    static let grey300 = UIColor(hex: "#E6E3DC")
    static let grey200 = UIColor(hex: "#F3F0E8")
    static let grey100 = UIColor(hex: "#FBF8F0")
    static let grey0 = UIColor(hex: "#FFFCF5")
}

// Example
// let buttonColor = .mainColor
// $0.textColor = UIColor.bgcPrimary
