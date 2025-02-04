//
//  LoginRequests.swift
//  Duckmelang
//
//  Created by 김연우 on 2/3/25.
//

import Foundation
import Moya


//문자 전송 요청 모델
struct VerificationCodeRequest: Codable {
    let phoneNum: String
}

//문자 인증 모델
struct VerifyCode: Codable {
    let phoneNum: String
    let certificationCode: String
}
