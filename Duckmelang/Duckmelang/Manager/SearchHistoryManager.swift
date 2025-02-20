//
//  SearchHistoryManager.swift
//  Duckmelang
//
//  Created by 주민영 on 2/20/25.
//

import Foundation

class SearchHistoryManager {
    private let key = "recentKeyword"
    private let maxItems = 10 // 최대 저장 개수 (10개)

    // 🔹 검색어 저장 (최대 10개 유지)
    func saveSearchQuery(_ query: String) {
        var searches = getSearchHistory()
        
        // 중복 검색어 제거
        if let index = searches.firstIndex(of: query) {
            searches.remove(at: index)
        }
        
        // 최신 검색어를 맨 앞에 추가
        searches.insert(query, at: 0)
        
        // 최대 개수 제한
        searches = Array(searches.prefix(maxItems))
        
        // 저장
        UserDefaults.standard.set(searches, forKey: key)
    }

    // 🔹 저장된 검색어 가져오기
    func getSearchHistory() -> [String] {
        return UserDefaults.standard.stringArray(forKey: key) ?? []
    }

    // 🔹 검색어 전체 삭제
    func clearSearchHistory() {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    // 🔹 특정 인덱스의 검색어 삭제
    func deleteSearchQuery(at index: Int) {
        var searches = getSearchHistory()
        guard index < searches.count else { return }
        
        searches.remove(at: index)
        UserDefaults.standard.set(searches, forKey: key)
    }
}
