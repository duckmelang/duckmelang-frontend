//
//  LoginResponse.swift
//  Duckmelang
//
//  Created by 김연우 on 2/4/25.
//

import Foundation

// 토큰 재발급 응답모델
public struct RefreshTokenResponseResult: Codable {
    public let accessToken: String
    public let refreshToken: String
}

// Login 응답 결과
public struct LoginResult: Codable {
    public let memberId: Int
    public let accessToken: String
    public let refreshToken: String
    public let profileComplete: Bool
}

// 중복 확인 응답 모델
public struct CheckResult: Codable {
    public let isDuplicate: Bool
}

// 아이디 찾기 응답 모델
public struct FindIdResult: Codable {
    public let loginId: String
}
