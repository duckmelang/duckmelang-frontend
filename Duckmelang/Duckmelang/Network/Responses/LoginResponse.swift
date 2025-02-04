//
//  LoginResponse.swift
//  Duckmelang
//
//  Created by 김연우 on 2/4/25.
//

import Foundation

//인증번호 응답 모델
public struct VerifyCodeResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: String?
}
