//
//  LoginAPI.swift
//  Duckmelang
//
//  Created by 김연우 on 2/3/25.
//

import UIKit
import Moya

// 1 명세서 당 1 API enum 정의하기
// case 이름은 반드시 method로 시작하기 !!
// 예) .post~, .patch~, .get~, .delete~
// 매개변수를 사용하지 않는 곳이라면 생략하고 case 이름만 작성해도 됨
// 예) .postReviews(let memberId) : X / .postReviews : O

public enum LoginAPI {
    case postLogin(email: String, password: String)
    case postSignUp(email: String, password: String)
    case postSendVerificationCode(phoneNumber: String) //인증번호 전송
    case postVerifyCode(phoneNumber: String, code: String) //인증번호 인증
    case kakaoLogin
    case googleLogin
}

extension LoginAPI: TargetType {
    // Domain.swift 파일 참고해서 맞는 baseURL 적용하기
    // 모두 같은 baseURL을 사용한다면 default로 지정하기
    public var baseURL: URL {
        switch self {
        case .postLogin(email: _, password: _):
            guard let url = URL(string: API.postURL) else {
                fatalError("postURL 오류")
            }
            return url
        case .postSignUp(email: _, password: _):
            guard let url = URL(string: API.memberURL) else {
                fatalError("memberURL 오류")
            }
            return url
        case .postSendVerificationCode(phoneNumber: _):
            guard let url = URL(string: API.smsURL) else {
                fatalError("smsURL 오류")
            }
            return url
        case .postVerifyCode(phoneNumber: _, code: _):
            guard let url = URL(string: API.smsURL) else {
                fatalError("smsURL 오류")
            }
            return url
        case .kakaoLogin:
            guard let url = URL(string: API.oauthURL) else {
                fatalError("oauthURL 오류")
            }
            return url
        case .googleLogin:
            guard let url = URL(string: API.oauthURL) else {
                fatalError("oauthURL 오류")
            }
            return url
        }
    }
    
    public var path: String {
        // 기본 URL + path로 URL 구성
        switch self {
        case .postLogin:
            return "/login"
        case .postSignUp:
            return "/signup"
        case .postSendVerificationCode:
            return "/send"
        case .postVerifyCode:
            return "/verify"
        case .kakaoLogin:
            return "/kakao"
        case .googleLogin:
            return "/google"
        
        }
    }
    
    public var method: Moya.Method {
        // 가장 많이 호출되는 post을 default로 처리하기
        // 동일한 method는 한 case로 처리할 수 있음
        switch self {
        case .kakaoLogin, .googleLogin:
            return .get
        default:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .postLogin(let email, let password),
                .postSignUp(let email, let password):
            return .requestParameters(
                parameters: ["email": email, "password": password],
                encoding: JSONEncoding.default
            )
        case .postSendVerificationCode(let phoneNumber):
            return .requestParameters(
                parameters: ["phoneNumber": phoneNumber],
                encoding: JSONEncoding.default
            )
        case .postVerifyCode(let phoneNumber, let code):
            return .requestParameters(
                parameters: ["phoneNumber": phoneNumber, "code": code],
                encoding: JSONEncoding.default
            )
        case .kakaoLogin, .googleLogin:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        default :
            return ["Content-Type": "application/json"]
        }
    }
}
