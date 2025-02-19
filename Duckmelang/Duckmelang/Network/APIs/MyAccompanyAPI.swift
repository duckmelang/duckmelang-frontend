//
//  MyAccompanyAPI.swift
//  Duckmelang
//
//  Created by 주민영 on 2/3/25.
//

import UIKit
import Moya

// 1 명세서 당 1 API enum 정의하기
// case 이름은 반드시 method로 시작하기 !!
// 예) .post~, .patch~, .get~, .delete~
// 매개변수를 사용하지 않는 곳이라면 생략하고 case 이름만 작성해도 됨
// 예) .postReviews(let memberId) : X / .postReviews : O

public enum MyAccompanyAPI {
    case getPendingRequests(memberId: Int, page: Int)
    case getSentRequests(memberId: Int, page: Int)
    case getReceivedRequests(memberId: Int, page: Int)
    case postRequestSucceed(applicationId: Int, memberId: Int)
    case postRequestFailed(applicationId: Int, memberId: Int)
    case getBookmarks(page: Int)
    case getMyPosts(page: Int)
    case getPostDetail(postId: Int)
}

extension MyAccompanyAPI: TargetType {
    // Domain.swift 파일 참고해서 맞는 baseURL 적용하기
    // 모두 같은 baseURL을 사용한다면 default로 지정하기
    public var baseURL: URL {
        switch self {
        case .getPendingRequests, .getSentRequests, .getReceivedRequests, .postRequestSucceed, .postRequestFailed:
            guard let url = URL(string: API.requestURL) else {
                fatalError("requestURL 오류")
            }
            return url
        case .getMyPosts, .getPostDetail:
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
        // 기본 URL + path로 URL 구성
        switch self {
        case .getPendingRequests:
            return "/received/pending"
        case .getSentRequests:
            return "/sent"
        case .getReceivedRequests:
            return "/received"
        case .postRequestSucceed(let applicationId, _):
            return "/received/succeed/\(applicationId)"
        case .postRequestFailed(let applicationId, _):
            return "/received/failed/\(applicationId)"
        case .getBookmarks:
            return "/bookmarks"
        case .getMyPosts:
            return "/my"
        case .getPostDetail(let postId):
            return "/\(postId)"
        }
    }
    
    public var method: Moya.Method {
        // 가장 많이 호출되는 get을 default로 처리하기
        // 동일한 method는 한 case로 처리할 수 있음
        switch self {
        case .postRequestSucceed, .postRequestFailed:
            return .post
        default:
            return .get
        }
    }
    
    public var task: Moya.Task {
        // 동일한 task는 한 case로 처리할 수 있음
        switch self {
        case .getPendingRequests(let memberId, let page), .getSentRequests(let memberId, let page), .getReceivedRequests(let memberId, let page):
            return .requestParameters(parameters: ["memberId": memberId, "page": page], encoding: URLEncoding.queryString)
        case .getBookmarks(let page), .getMyPosts(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        case .postRequestSucceed(_, let memberId), .postRequestFailed(_, let memberId):
            return .requestParameters(parameters: ["memberId": memberId], encoding: URLEncoding.queryString)
        case .getPostDetail:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        default :
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwiaWF0IjoxNzM5OTQ1OTQ5LCJleHAiOjE3Mzk5NDk1NDl9.D-G_E0ObDDk8JrHn4_LrvA7BEQZ0U-c6yLkJ03zutEo"
            ]
        }
    }
}


