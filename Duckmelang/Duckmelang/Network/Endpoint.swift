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
    case getMyPosts(memberId: Int, page: Int)
    case getBookmarks(memberId: Int, page: Int)
    case getProfileImage(memberId: Int, page: Int)
}

extension AllEndpoint: TargetType {
    public var baseURL: URL {
        switch self {
        case .getMyPosts(_, _):
            guard let url = URL(string: API.postURL) else {
                fatalError("baseURL 오류")
            }
            return url
        case .getBookmarks(_, _), .getProfileImage(_, _):
            guard let url = URL(string: API.baseURL) else {
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
        }
    }
    
    public var path: String {
        switch self {
        case .sendVerificationCode:
            return "/send"
        case .verifyCode:
            return "/verify"
        case .getMyPosts(_, _):
            return "/my"
        case .getBookmarks(let memberId, _):
            return "/bookmarks/\(memberId)"
        case .getProfileImage(_, _):
            return "/mypage/profile/image/"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .sendVerificationCode, .verifyCode:
            return .post
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
        case .getMyPosts(let memberId, let page), .getProfileImage(let memberId, let page):
            return .requestParameters(parameters: ["memberId": memberId, "page": page], encoding: URLEncoding.queryString)
        case .getBookmarks(_, let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        default :
            return ["Content-Type": "application/json"]
        }
    }
}
