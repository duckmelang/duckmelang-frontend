//
//  LoginResponse.swift
//  Duckmelang
//
//  Created by 김연우 on 2/4/25.
//

import Foundation

//토큰 재발급 응답모델
struct RefreshTokenResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: RefreshTokenResponseResult
}

struct RefreshTokenResponseResult : Codable {
    let accessToken: String
    let refreshToken: String
}

//소셜 로그인 응답모델
struct SocialLoginResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: SocialLoginResult
}

struct SocialLoginResult: Codable {
    let memberId: Int
    let email: String
    let provider: String
    let accessToken: String
    let refreshToken: String
    let profileComplete: Bool
}

//로그인 응답 모델
struct LoginResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: LoginResult
}

//Login 응답 결과
struct LoginResult: Codable {
    let accessToken: String
    let refreshToken: String
}

//인증번호 응답 모델
public struct VerifyCodeResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String?
}

//닉네임 중복 확인 응답 모델
struct NicknameCheckResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: NicknameCheckResult
}

struct NicknameCheckResult: Decodable {
    let message: String
    let available: Bool
}

//닉네임, 생년월일, 성별 중복 응답 모델
struct PatchMemberProfileErrorResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
}

//닉네임, 생년월일, 성별 응답 모델
struct PatchMemberProfileSuccessResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: MemberProfile
}

// 회원 프로필 데이터 모델
struct MemberProfile: Codable {
    let memberId: Int
    let nickname: String
    let birth: String
    let gender: String
}

//모든 아이돌 목록 받아오는 모델 : 전체보기 (무한스크롤로 수정 가능성 O)
    // 최상위 JSON 구조
struct IdolListResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: IdolListResult
}

    // result 내부 데이터
struct IdolListResult: Codable {
    let idolList: [Idol]
}

    // 개별 아이돌 정보
struct Idol: Codable {
    let idolId: Int
    let idolName: String
    let idolImage: String
}

//isSelected속성을 추가한 Idol모델
struct SelectableIdol {
    let idol: Idol
    var isSelected: Bool
}

// 행사 목록 응답 모델
struct EventListResponse: Codable {
    let isSuccess: Bool
    let code, message: String
    let result: EventResult
}

struct EventResult: Codable {
    let eventCategoryList: [EventCategoryList]
}

struct EventCategoryList: Codable {
    let eventID: Int
    let eventName: String
    let eventKind: EventKind

    enum CodingKeys: String, CodingKey {
        case eventID = "eventId"
        case eventName, eventKind
    }
}

enum EventKind: String, Codable {
    case 공연 = "공연"
    case 행사 = "행사"
}

//행사 목록 post 응답 모델

//지뢰 키워드 설정 응답 모델
struct MakeProfileLandmineResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: LandmineResult
}

struct LandmineResult: Decodable {
    let memberId: Int
    let landmineContents: [String]
}
