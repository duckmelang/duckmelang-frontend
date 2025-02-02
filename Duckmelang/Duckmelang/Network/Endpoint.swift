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
    case EditProfile(memberId: Int, profileData: EditProfileRequest)
    case getReviews(memberId: Int)
}

extension AllEndpoint: TargetType {
    public var baseURL: URL {
        switch self {
        case .getMyPosts(_, _):
            guard let url = URL(string: API.postURL) else {
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
        case .getReviews(memberId: _):
            return "/mypage/reviews"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .EditProfile(profileData: _):
            return .patch
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
        case .EditProfile(let memberId, let profileData):
            return .requestCompositeParameters(
                bodyParameters: [
                    "memberProfileImageURL": profileData.memberProfileImageURL,
                    "nickname": profileData.nickname,
                    "introduction": profileData.introduction
                ],
                bodyEncoding: JSONEncoding.default,
                urlParameters: ["memberId": memberId] // Query Parameter로 전송
            )
        case .getReviews(memberId: let memberId):
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

