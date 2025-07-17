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
    case getCheckNickname(loginId: String) // 아이디 중복 확인
    case postRefreshToken(refreshToken: RefreshTokenRequest) // 토큰 재발급
    case getCheckPhoneNum(phoneNum: String) // 전화번호 중복 확인
    case postLogin(login: LoginRequest) // 로그인
    case patchPassword(login: NewPasswordRequest) // 비밀번호 변경
    case getFindId(phoneNum: String) // 아이디 찾기
    
    case kakaoLogin(accessToken: KakaoLoginRequest) // 카카오 로그인
}

extension LoginEndpoint: TargetType {
    // Domain.swift 파일 참고해서 맞는 baseURL 적용하기
    // 모두 같은 baseURL을 사용한다면 default로 지정하기
    public var baseURL: URL {
        switch self {
        default:
            guard let url = URL(string: API.authURL) else {
                fatalError("authURL 오류")
            }
            return url
        }
    }
    
    public var path: String {
        // 기본 URL + path로 URL 구성
        switch self {
        case .getCheckNickname:
            return "/nickname"
        case .postRefreshToken:
            return "/token/refresh"
        case .getCheckPhoneNum:
            return "/phone"
        case .postLogin:
            return "/login"
        case .patchPassword:
            return "/find-password"
        case .getFindId:
            return "/find-id"
        case .kakaoLogin:
            return "/kakao-login"
        }
    }
    
    public var method: Moya.Method {
        // 가장 많이 호출되는 post을 default로 처리하기
        // 동일한 method는 한 case로 처리할 수 있음
        switch self {
        case .postRefreshToken, .postLogin, .kakaoLogin:
            return .post
        case .patchPassword:
            return .patch
        default:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getCheckNickname(let loginId):
            return .requestParameters(parameters: ["loginId": loginId], encoding: URLEncoding.queryString)
        case .postRefreshToken(let refreshToken):
            return .requestJSONEncodable(refreshToken)
        case .postLogin(let login):
            return .requestJSONEncodable(login)
        case .patchPassword(let login):
            return .requestJSONEncodable(login)
        case .getCheckPhoneNum(let phoneNum), .getFindId(let phoneNum):
            return .requestParameters(parameters: ["phoneNum": phoneNum], encoding: URLEncoding.queryString)
        case .kakaoLogin(let accessToken):
            return .requestJSONEncodable(accessToken)
        }
    }
        
    public var headers: [String : String]? {
        switch self {
        default :
            return ["Content-Type": "application/json"]
        }
    }
}
