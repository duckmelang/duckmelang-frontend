//
//  LoginResponse.swift
//  Duckmelang
//
//  Created by 김연우 on 2/4/25.
//

import Foundation

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
