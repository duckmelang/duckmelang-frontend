//
//  PostDetailAccompanyCell.swift
//  Duckmelang
//
//  Created by KoNangYeon on 2/5/25.
//

import UIKit

struct PostDetailAccompanyModel {
    let title: String
    let info: String
}

extension PostDetailAccompanyModel {
    static func dummy() -> [PostDetailAccompanyModel] {
        return [
            PostDetailAccompanyModel(title: "아이돌", info: "aespa(에스파)"),
            PostDetailAccompanyModel(title: "행사 종류", info: "콘서트"),
            PostDetailAccompanyModel(title: "행사 날짜", info: "3월 16일"),
        ]
    }
}
