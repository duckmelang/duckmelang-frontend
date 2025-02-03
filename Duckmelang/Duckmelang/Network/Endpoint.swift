//
//  Endpoint.swift
//  Duckmelang
//
//  Created by 주민영 on 1/28/25.
//

import UIKit
import Moya

public enum AllEndpoint {
    case postReviews(memberId: Int, reviewData: ReviewDTO)
    case getReviewsInformation(memberId: Int, myId: Int)
    case getMyPosts(memberId: Int, page: Int)
    case getBookmarks(memberId: Int, page: Int)
    
    case getPendingRequests(memberId: Int, page: Int)
    case getSentRequests(memberId: Int, page: Int)
    case getReceivedRequests(memberId: Int, page: Int)
    case postRequestSucceed(applicationId: Int, memberId: Int)
    case postRequestFailed(applicationId: Int, memberId: Int)
    
    case getProfileImage(memberId: Int, page: Int)
    case getProfile(memberId: Int) // 프로필 조회 API 추가
    case EditProfile(memberId: Int, profileData: EditProfileRequest)
    case getReviews(memberId: Int)
}

extension AllEndpoint: TargetType {
    public var baseURL: URL {
        switch self {
        case .postReviews(_, _), .getReviewsInformation(_, _):
            guard let url = URL(string: API.reviewURL) else {
                fatalError("reviewURL 오류")
            }
            return url
        case .getPendingRequests(_, _), .getSentRequests(_, _), .getReceivedRequests(_, _), .postRequestSucceed(_, _), .postRequestFailed(_, _):
            guard let url = URL(string: API.requestURL) else {
                fatalError("requestURL 오류")
            }
            return url
        case .getMyPosts(_, _):
            guard let url = URL(string: API.postURL) else {
                fatalError("postURL 오류")
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
        case .postReviews(_, _):
            return ""
        case .getReviewsInformation(_, _):
            return "/information"
        case .getMyPosts(_, _):
            return "/my"
        case .getBookmarks(let memberId, _):
            return "/bookmarks/\(memberId)"
        case .getPendingRequests(_, _):
            return "/received/pending"
        case .getSentRequests(_, _):
            return "/sent"
        case .getReceivedRequests(_, _):
            return "/received"
        case .postRequestSucceed(let applicationId, _):
            return "/received/succeed/\(applicationId)"
        case .postRequestFailed(let applicationId, _):
            return "/received/failed/\(applicationId)"
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
        case .postReviews(_, _), .postRequestSucceed(_, _), .postRequestFailed(_, _):
            return .post
        case .EditProfile(profileData: _):
            return .patch
        default:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .postReviews(let memberId, let reviewData):
            guard let jsonData = try? JSONEncoder().encode(reviewData) else {
                return .requestPlain
            }
            return .requestCompositeData(bodyData: jsonData, urlParameters: ["memberId": memberId])
        case .getReviewsInformation(let memberId, let myId):
            return .requestParameters(parameters: ["memberId": memberId, "myId": myId], encoding: URLEncoding.queryString)
        case .getMyPosts(let memberId, let page), .getPendingRequests(let memberId, let page), .getSentRequests(let memberId, let page), .getReceivedRequests(let memberId, let page), .getProfileImage(let memberId, let page):
            return .requestParameters(parameters: ["memberId": memberId, "page": page], encoding: URLEncoding.queryString)
        case .getBookmarks(_, let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        case .getProfile(memberId: let memberId), .postRequestSucceed(_, let memberId), .postRequestFailed(_, let memberId):
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

