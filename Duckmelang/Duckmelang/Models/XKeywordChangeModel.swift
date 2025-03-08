//
//  PostRecommendedFilterModel.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/27/25.
//

import UIKit

struct XKeywordChangeModel {
    let filter: String
}

extension XKeywordChangeModel {
    static func dummy() -> [XKeywordChangeModel] {
        return [
            XKeywordChangeModel(filter: "기존"),
            XKeywordChangeModel(filter: "키워드"),
            XKeywordChangeModel(filter: "제거")
        ]
    }
}
