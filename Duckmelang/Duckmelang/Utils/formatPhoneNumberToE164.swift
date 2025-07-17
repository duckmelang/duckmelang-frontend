//
//  formatPhoneNumberToE164.swift
//  Duckmelang
//
//  Created by 주민영 on 7/4/25.
//

import UIKit

// MARK: - 국가코드 시작하는 번호로 변경
func formatPhoneNumberToE164(_ phoneNumber: String) -> String {
    // 1. 숫자만 추출 (하이픈, 공백 제거)
    let digits = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

    // 2. 010으로 시작하면 +82로 바꿔줌
    if digits.hasPrefix("0") {
        let withoutZero = String(digits.dropFirst()) // 010 → 10
        return "+82" + withoutZero
    } else if digits.hasPrefix("82") {
        return "+" + digits
    } else if digits.hasPrefix("+82") {
        return digits
    } else {
        // 이미 국제번호거나 다른 국가일 수 있음
        return digits
    }
}
