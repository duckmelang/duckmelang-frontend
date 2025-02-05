//
//  UserName.swift
//  Duckmelang
//
//  Created by 김연우 on 2/1/25.
//

import UIKit

struct UserNameModel{
    var username: String
}

extension UserNameModel {
    static func dummyName() -> [UserNameModel] {
        return [
            UserNameModel(username: "유저1"),
            UserNameModel(username: "유저2"),
            UserNameModel(username: "유저3"),
            UserNameModel(username: "유저4"),
            UserNameModel(username: "유저5")
        ]
    }
}
