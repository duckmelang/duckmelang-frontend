//
//  RecentSearchModel.swift
//  Duckmelang
//
//  Created by 김연우 on 2/1/25.
//

import Foundation

struct SearchKeyword {
    let keyword: String
}

extension SearchKeyword {
    static func dummy1() -> [SearchKeyword] {
        return [
            SearchKeyword(keyword: "최근검색어 0"),
            SearchKeyword(keyword: "최근검색어 1"),
            SearchKeyword(keyword: "검색어 텍스트박스 width는 최대 140pt입니다."),
            SearchKeyword(keyword: "최근검색어 2"),
            SearchKeyword(keyword: "최근검색어 3"),
            SearchKeyword(keyword: "최근검색어 4"),
        ]
    }
}
