//
//  LoginEndpoint.swift
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

public enum LoginEndpoint {
    case postRefreshToken(refreshToken: RefreshTokenRequest) // 토큰 재발급
    case postLogout // 로그아웃
    case postLogin(login: LoginRequest) // 로그인
    
    case kakaoLogin // 카카오로그인
    case googleLogin // 구글로그인
    case getOAuthTokenKakao(memberId: Int)
    case getOAuthTokenGoogle(memberId: Int)
    
    case postSendVerificationCode(phoneNum: VerificationCodeRequest) // 인증번호 전송
    case postVerifyCode(verifyCode: VerifyCode) // 인증번호 인증
}

extension LoginEndpoint: TargetType {
    // Domain.swift 파일 참고해서 맞는 baseURL 적용하기
    // 모두 같은 baseURL을 사용한다면 default로 지정하기
    public var baseURL: URL {
        switch self {
        case .kakaoLogin, .googleLogin:
            guard let url = URL(string: API.oauthURL) else {
                fatalError("oauthURL 오류")
            }
            return url
        case .getOAuthTokenKakao, .getOAuthTokenGoogle:
            guard let url = URL(string: API.oauthCodeURL) else {
                fatalError("oauthTokenURL 오류")
            }
            return url
        case .postSendVerificationCode, .postVerifyCode:
            guard let url = URL(string: API.smsURL) else {
                fatalError("smsURL 오류")
            }
            return url
        default:
            guard let url = URL(string: API.baseURL) else {
                fatalError("baseURL 오류")
            }
            return url
        }
    }
    
    public var path: String {
        // 기본 URL + path로 URL 구성
        switch self {
        case .postRefreshToken:
            return "/token/refresh"
        case .postLogout:
            return "/logout"
        case .postLogin:
            return "/login"
        case .kakaoLogin, .getOAuthTokenKakao:
            return "/kakao"
        case .googleLogin, .getOAuthTokenGoogle:
            return "/google"
        case .postSendVerificationCode:
            return "/send"
        case .postVerifyCode:
            return "/verify"
        }
    }
    
    public var method: Moya.Method {
        // 가장 많이 호출되는 post을 default로 처리하기
        // 동일한 method는 한 case로 처리할 수 있음
        switch self {
        case .kakaoLogin, .getOAuthTokenKakao, .googleLogin, .getOAuthTokenGoogle:
            return .get
        default:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .postRefreshToken(let refreshToken):
            return .requestJSONEncodable(refreshToken)
        case .postLogin(let login):
            return .requestJSONEncodable(login)
        case .getOAuthTokenKakao(let memberId), .getOAuthTokenGoogle(let memberId):
            return .requestParameters(parameters: ["memberId": memberId], encoding: URLEncoding.default)
        case .postSendVerificationCode(let phoneNum):
            return .requestJSONEncodable(phoneNum)
        case .postVerifyCode(let verifyCode):
            return .requestJSONEncodable(verifyCode)
        case .postLogout, .kakaoLogin, .googleLogin:
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
