//
//  EventModel.swift
//  Duckmelang
//
//  Created by 김연우 on 1/20/25.
//


import Foundation

/// 이벤트 태그 (공연 및 행사)
enum EventTag: String, Codable, CaseIterable {
    // 공연 태그
    case 팬미팅, 콘서트, 전국투어, 사전녹화, 대학축제, 해외투어
    // 행사 태그
    case 생일카페, 전시회, 팬사인회, 팝업스토어, 기타
}

/// 이벤트 데이터 모델 (단일 선택)
struct Event: Identifiable, Codable {
    var id: Int
    var tag: EventTag      // 단일 선택 태그
    
    /// 샘플 데이터
        static let sampleEvents: [Event] = [
            Event(id: 0, tag: .콘서트),
            Event(id: 1, tag: .팬미팅),
            Event(id: 2, tag: .전시회),
            Event(id: 3, tag: .대학축제),
            Event(id: 4, tag: .팬사인회),
            Event(id: 5, tag: .해외투어),
            Event(id: 6, tag: .생일카페)
        ]
}
