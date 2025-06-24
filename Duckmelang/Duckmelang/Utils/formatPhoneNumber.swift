//
//  formatPhoneNumber.swift
//  Duckmelang
//
//  Created by 주민영 on 6/23/25.
//

func formatPhoneNumber(_ number: String) -> String {
    let digits = number.filter { $0.isNumber }

    if digits.count <= 3 {
        return digits
    } else if digits.count <= 7 {
        let prefix = String(digits.prefix(3))
        let suffix = String(digits.suffix(from: digits.index(digits.startIndex, offsetBy: 3)))
        return "\(prefix)-\(suffix)"
    } else if digits.count <= 11 {
        let prefix = String(digits.prefix(3))
        let mid = String(digits[digits.index(digits.startIndex, offsetBy: 3)..<digits.index(digits.startIndex, offsetBy: 7)])
        let suffix = String(digits.suffix(from: digits.index(digits.startIndex, offsetBy: 7)))
        return "\(prefix)-\(mid)-\(suffix)"
    } else {
        return String(digits.prefix(11)) // 최대 11자리로 제한
    }
}
