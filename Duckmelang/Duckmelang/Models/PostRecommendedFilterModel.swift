//
//  PostRecommendedFilterModel.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/27/25.
//

import UIKit

struct PostRecommendedFilterModel {
    let filter: String
}

extension PostRecommendedFilterModel {
    static func dummy() -> [PostRecommendedFilterModel] {
        return [
            PostRecommendedFilterModel(filter: "기존"),
            PostRecommendedFilterModel(filter: "키워드"),
            PostRecommendedFilterModel(filter: "제거")
        ]
    }
}
