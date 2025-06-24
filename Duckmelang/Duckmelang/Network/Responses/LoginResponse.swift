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

// 소셜 로그인 응답모델
public struct SocialLoginResult: Codable {
    public let memberId: Int
    public let email: String
    public let provider: String
    public let accessToken: String
    public let refreshToken: String
    public let profileComplete: Bool
}

// Login 응답 결과
public struct LoginResult: Codable {
    public let memberId: Int
    public let accessToken: String
    public let refreshToken: String
    public let profileComplete: Bool
}

// 인증번호 응답 모델
public struct VerifyCodeResponse: Codable {
    public let isSuccess: Bool
    public let code: String
    public let message: String
    public let result: String?
}
