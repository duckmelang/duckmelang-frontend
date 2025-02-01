//
//  Endpoint.swift
//  Duckmelang
//
//  Created by 주민영 on 1/28/25.
//

import UIKit
import Moya

public enum AllEndpoint {
    case getMyPosts(memberId: Int, page: Int)
    case getBookmarks(memberId: Int, page: Int)
    case getProfileImage(memberId: Int, page: Int)
    case getProfile(memberId: Int) // 프로필 조회 API 추가
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
        case .getProfile(memberId: _):
            guard let url = URL(string: API.baseURL) else {
                fatalError("baseURL 오류")
            }
            return url
        }
    }
    
    public var path: String {
        switch self {
        case .getMyPosts(_, _):
            return "/my"
        case .getBookmarks(let memberId, _):
            return "/bookmarks/\(memberId)"
        case .getProfileImage(_, _):
            return "/mypage/profile/image/"
        case .getProfile(memberId: _):
            return "/mypage/profile"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getMyPosts(let memberId, let page), .getProfileImage(let memberId, let page):
            return .requestParameters(parameters: ["memberId": memberId, "page": page], encoding: URLEncoding.queryString)
        case .getBookmarks(_, let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        case .getProfile(memberId: let memberId):
            return .requestParameters(parameters: ["memberId": memberId], encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        default :
            return ["Content-Type": "application/json"]
        }
    }
}
