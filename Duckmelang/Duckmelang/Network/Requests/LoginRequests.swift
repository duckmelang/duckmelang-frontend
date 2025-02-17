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

//좋아하는 아이돌 선택 모델
public struct SelectFavoriteIdolRequest: Encodable {
    let idolCategoryIds: [Int]
}

struct IdolList : Encodable{
    let idolId: Int
    let idolName: String
    let idolImage: String // 아이돌 로고
}

//MARK: - 더미데이터
extension IdolList {
    static func dummy1() -> [IdolList] {
        return [
            IdolList(idolId: 1, idolName: "New Jeans", idolImage: "logo_yellow"),
            IdolList(idolId: 2, idolName: "Aespa", idolImage: "logo_yellow"),
            IdolList(idolId: 3, idolName: "Kiss of Life", idolImage: "logo_yellow"),
            IdolList(idolId: 4, idolName: "IVE", idolImage: "logo_yellow"),
            IdolList(idolId: 5, idolName: "Seventeen", idolImage: "logo_yellow"),
            IdolList(idolId: 6, idolName: "LE SSERAFIM", idolImage: "logo_yellow")
        ]
    }
}
