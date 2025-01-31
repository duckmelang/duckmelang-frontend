//
//  ReviewModel.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/23/25.
//

import UIKit

struct ReviewModel {
    let nickname: String
    let gender: String
    let age: String
    let review: String
}

extension ReviewModel {
    static func dummy() -> [ReviewModel] {
        return [
            ReviewModel(nickname: "닉네임", gender: "여성", age: "나이", review: "엄청 친절하세요! 저랑 대화도 잘 통해서 좋았습니다:)"),
            ReviewModel(nickname: "닉네임", gender: "여성", age: "나이", review: "엄청 친절하세요! 저랑 대화도 잘 통해서 좋았습니다:)"),
            ReviewModel(nickname: "닉네임", gender: "여성", age: "나이", review: "엄청 친절하세요! 저랑 대화도 잘 통해서 좋았습니다:)")
        ]
    }
}
