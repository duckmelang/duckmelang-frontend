//
//  LoginResponse.swift
//  Duckmelang
//
//  Created by 김연우 on 2/4/25.
//

import Foundation

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

//닉네임, 생년월일, 성별 응답 모델
struct PatchMemberProfileResponse: Codable {
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
