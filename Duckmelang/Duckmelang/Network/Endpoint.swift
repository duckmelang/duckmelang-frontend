//
//  Endpoint.swift
//  Duckmelang
//
//  Created by 주민영 on 1/28/25.
//

import UIKit
import Moya

public enum AllEndpoint {
    case sendVerificationCode(phoneNumber: String)
    case verifyCode(phoneNumber: String, code: String)
    case login(email: String, password: String)
    case signUp(email: String, password: String)
    case getMyPosts(memberId: Int, page: Int)
    case getBookmarks(memberId: Int, page: Int)
    case getProfileImage(memberId: Int, page: Int)
    case kakaoLogin
    case googleLogin
    case getProfile(memberId: Int) // 프로필 조회 API 추가
    case EditProfile(profileData: EditProfileRequest)
}

extension AllEndpoint: TargetType {
    public var baseURL: URL {
        switch self {
        case .getMyPosts(_, _):
            guard let url = URL(string: API.postURL) else {
                fatalError("baseURL 오류")
            }
            return url
        case .sendVerificationCode(phoneNumber: _):
            guard let url = URL(string: API.smsURL) else {
                fatalError("baseURL 오류")
            }
            return url
        case .verifyCode(phoneNumber: _, code: _):
            guard let url = URL(string: API.smsURL) else {
                fatalError("baseURL 오류")
            }
            return url
        case .login(email: _, password: _):
            guard let url = URL(string: API.postURL) else {
                fatalError("baseURL 오류")
            }
            return url
        case .signUp(email: _, password: _):
            guard let url = URL(string: API.memberURL) else {
                fatalError("baseURL 오류")
            }
            return url
        case .kakaoLogin:
            guard let url = URL(string: API.oauthURL) else {
                fatalError("baseURL 오류")
            }
            return url
        case .googleLogin:
            guard let url = URL(string: API.oauthURL) else {
                fatalError("baseURL 오류")
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
        switch self {
        case .sendVerificationCode:
            return "/send"
        case .verifyCode:
            return "/verify"
        case .login:
            return "/login"
        case .kakaoLogin:
            return "/kakao"
        case .googleLogin:
            return "/google"
        case .signUp:
            return "/signup"
        case .getMyPosts(_, _):
            return "/my"
        case .getBookmarks(let memberId, _):
            return "/bookmarks/\(memberId)"
        case .getProfileImage(_, _):
            return "/mypage/profile/image/"
        case .getProfile(memberId: _):
            return "/mypage/profile"
        case .EditProfile(profileData: _):
            return "/mypage/profile/edit"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .sendVerificationCode, .verifyCode:
            return .post
        case .signUp:
            return .post
        case .kakaoLogin, .googleLogin:
            return .get
        case .EditProfile(profileData: _):
            return .patch
        default:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .sendVerificationCode(let phoneNumber):
            return .requestParameters(
                parameters: ["phoneNumber": phoneNumber],
                encoding: JSONEncoding.default
            )
        case .verifyCode(let phoneNumber, let code):
            return .requestParameters(
                parameters: ["phoneNumber": phoneNumber, "code": code],
                encoding: JSONEncoding.default
            )
        case .login(let email, let password):
            return .requestParameters(
                parameters: ["email": email, "password": password],
                encoding: JSONEncoding.default
            )
        case .kakaoLogin, .googleLogin:
            return .requestPlain
        case .signUp(let email, let password):
            return .requestParameters(
                parameters: [email: email, password: password],
                encoding: JSONEncoding.default
            )
        case .getMyPosts(let memberId, let page), .getProfileImage(let memberId, let page):
            return .requestParameters(parameters: ["memberId": memberId, "page": page], encoding: URLEncoding.queryString)
        case .getBookmarks(_, let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        case .getProfile(memberId: let memberId):
            return .requestParameters(parameters: ["memberId": memberId], encoding: URLEncoding.queryString)
        case .EditProfile(profileData: let profileData):
            return .requestJSONEncodable(profileData)
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        default :
            return ["Content-Type": "application/json"]
        }
    }
}

