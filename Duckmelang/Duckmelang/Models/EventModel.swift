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
    var id: UUID = UUID()  // 고유 ID
    var tag: EventTag      // 단일 선택 태그
    
    /// 샘플 데이터
        static let sampleEvents: [Event] = [
            Event(tag: .콘서트),
            Event(tag: .팬미팅),
            Event(tag: .전시회),
            Event(tag: .대학축제),
            Event(tag: .팬사인회),
            Event(tag: .해외투어),
            Event(tag: .생일카페)
        ]
}
