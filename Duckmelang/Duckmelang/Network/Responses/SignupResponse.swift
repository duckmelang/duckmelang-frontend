//
//  SignupResponse.swift
//  Duckmelang
//
//  Created by 주민영 on 3/28/25.
//

// 회원가입 응답 모델
public struct SignupResponseResult: Codable {
    public let memberId: Int
    public let createdAt: String
    public let profileComplete: Bool
}

// 닉네임 중복 확인 응답 모델
public struct NicknameCheckResult: Decodable {
    public let message: String
    public let available: Bool
}

// 회원 프로필 데이터 모델
public struct MemberProfile: Codable {
    public let memberId: Int
    public let nickname: String
    public let birth: String
    public let gender: String
}

// 프로필 사진 설정 모델
public struct MemberProfileImage: Codable {
    public let memberId: Int
    public let memberProfileImageURL: String
    public let `public`: Bool
}

// 덕질하는 아이돌 선택 설정 모델
public struct MemberIdol: Codable {
    public let memberId: Int
    public let idolCategoryIds: [Int]
}

// 관심있는 행사 선택 설정 모델
public struct MemberEvent: Codable {
    public let memberId: Int
    public let eventCategoryIds: [Int]
}

// 모든 아이돌 목록 받아오는 모델
public struct IdolListResult: Codable {
    public let idolList: [Idol]
}

// 개별 아이돌 정보
public struct Idol: Codable, Equatable {
    public let idolId: Int
    public let idolName: String
    public let idolImage: String
    
    public static func == (lhs: Idol, rhs: Idol) -> Bool {
        return lhs.idolId == rhs.idolId
    }
}

// isSelected 속성을 추가한 Idol 모델
public struct SelectableIdol {
    public let idol: Idol
    public var isSelected: Bool
}

// 행사 목록 응답 모델
public struct EventResult: Codable {
    public let eventCategoryList: [EventCategoryList]
}

public struct EventCategoryList: Codable {
    public let eventID: Int
    public let eventName: String
    public let eventKind: EventKind

    public enum CodingKeys: String, CodingKey {
        case eventID = "eventId"
        case eventName, eventKind
    }
}

public enum EventKind: String, Codable {
    case 공연 = "공연"
    case 행사 = "행사"
}

// 지뢰 키워드 설정 응답 모델
public struct LandmineResult: Decodable {
    public let memberId: Int
    public let landmineContents: [String]
}

// 자기소개 설정 응답모델
public struct IntroResult: Decodable {
    public let memberId: Int
    public let introContent: String
}
