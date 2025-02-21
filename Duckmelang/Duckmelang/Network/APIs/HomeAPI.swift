//
//  HomeAPI.swift
//  Duckmelang
//
//  Created by 주민영 on 2/21/25.
//

import UIKit
import Moya

// 1 명세서 당 1 API enum 정의하기
// case 이름은 반드시 method로 시작하기 !!
// 예) .post~, .patch~, .get~, .delete~
// 매개변수를 사용하지 않는 곳이라면 생략하고 case 이름만 작성해도 됨
// 예) .postReviews(let memberId) : X / .postReviews : O

public enum HomeAPI {
    case getHomePosts(page: Int)
    case getIdolPosts(idolId: Int, page: Int)
    case getIdols
    case postPosts(formData: [MultipartFormData])
    case postBookmark(postId: Int)
}

extension HomeAPI: TargetType {
    // Domain.swift 파일 참고해서 맞는 baseURL 적용하기
    // 모두 같은 baseURL을 사용한다면 default로 지정하기
    public var baseURL: URL {
        switch self {
        default:
            guard let url = URL(string: API.postURL) else {
                fatalError("postURL 오류")
            }
            return url
        }
    }
    
    public var path: String {
        // 기본 URL + path로 URL 구성
        switch self {
        case .getHomePosts:
            return ""
        case .getIdolPosts(let idolId, _):
            return "/idols/\(idolId)"
        case .getIdols:
            return "/idols"
        case .postPosts:
            return ""
        case .postBookmark(postId: let postId):
            return "/\(postId)/bookmarks"
        }
    }
    
    public var method: Moya.Method {
        // 가장 많이 호출되는 get을 default로 처리하기
        // 동일한 method는 한 case로 처리할 수 있음
        switch self {
        case .postPosts, .postBookmark:
            return .post
        default:
            return .get
        }
    }
    
    public var task: Moya.Task {
        // 동일한 task는 한 case로 처리할 수 있음
        switch self {
        case .getHomePosts(let page), .getIdolPosts(_, let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        case .postPosts(let formData):
            return .uploadMultipart(formData)
        case .getIdols, .postBookmark:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .postPosts:
            return [
                "Content-Type": "multipart/form-data"
            ]
        default :
            return [
                "Content-Type": "application/json"
            ]
        }
    }
}


