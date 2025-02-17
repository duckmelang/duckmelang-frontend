//
//  LoginRequests.swift
//  Duckmelang
//
//  Created by 김연우 on 2/3/25.
//

import Foundation
import Moya


//로그인 요청 모델
struct LoginRequest: Codable {
    let email: String
    let password: String
}

//회원가입 요청 모델
struct SignupRequest: Codable {
    let email: String
    let password: String
}

//문자 전송 요청 모델
struct VerificationCodeRequest: Codable {
    let phoneNum: String
}

//문자 인증 모델
struct VerifyCode: Codable {
    let phoneNum: String
    let certificationCode: String
}

//닉네임, 생년월일, 성별 설정 모델
public struct PatchMemberProfileRequest: Encodable {
    let nickname: String
    let birth: String
    let gender: String
}
