//
//  isValidPassword.swift
//  Duckmelang
//
//  Created by 주민영 on 7/4/25.
//

import UIKit

// 영문 + 숫자 조합, 8자 이상인지 확인
func isValidPassword(_ text: String) -> Bool {
    let regex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d!@#$%^&*(),.?\":{}|<>~`\\[\\]\\\\/+=_-]{8,}$"
    return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
}
