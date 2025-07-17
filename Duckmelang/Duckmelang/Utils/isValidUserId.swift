//
//  isValidUserId.swift
//  Duckmelang
//
//  Created by 주민영 on 7/14/25.
//

import Foundation

func isValidUserId(_ id: String) -> Bool {
    let regex = "^[a-zA-Z0-9]{4,10}$"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    return predicate.evaluate(with: id)
}
