//
//  MyPageAPI.swift
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

public enum MyPageAPI {
    case getProfileImage(page: Int)
    case getProfile
    case patchProfile(profileData: EditProfileRequest)
    case getMyPosts(page: Int)
    case getReviews
    case getMyPostDetail(postId: Int)
    case postProfileImage(profileImage: [MultipartFormData])
    case getProfileEdit
    case deletePost(postId: Int)
    case getIdolList
    case getSearchIdol(keyword: String)
    case postIdol(idolId: Int)
    case deleteIdol(idolId: Int)
}

extension MyPageAPI: TargetType {
    // Domain.swift 파일 참고해서 맞는 baseURL 적용하기
    // 모두 같은 baseURL을 사용한다면 default로 지정하기
    public var baseURL: URL {
        switch self {
        case.getMyPostDetail, .deletePost:
            guard let url = URL(string: API.postURL) else {
                fatalError("mypageURL 오류")
            }
            return url
        default:
            guard let url = URL(string: API.mypageURL) else {
                fatalError("mypageURL 오류")
            }
            return url
        }
    }
    
    public var path: String {
        // 기본 URL + path로 URL 구성
        switch self {
        case .getProfileImage:
            return "/profile/image/"
        case .getProfile:
            return "/profile"
        case .patchProfile, .getProfileEdit:
            return "/profile/edit"
        case .getMyPosts:
            return "/posts"
        case .getReviews:
            return "/reviews"
        case .getMyPostDetail(postId: let postId), .deletePost(postId: let postId):
            return "/\(postId)"
        case .postProfileImage:
            return "/profile/image/edit"
        case .getIdolList:
            return "/idols"
        case .deleteIdol(idolId: let idolId), .postIdol(idolId: let idolId):
            return "/idols/\(idolId)"
        case .getSearchIdol:
            return "/idols/search"
        }
    }
    
    public var method: Moya.Method {
        // 가장 많이 호출되는 get을 default로 처리하기
        // 동일한 method는 한 case로 처리할 수 있음
        switch self {
        case .patchProfile:
            return .patch
        case .postProfileImage, .postIdol:
            return .post
        case .deletePost, .deleteIdol:
            return .delete
        default:
            return .get
        }
    }
    
    public var task: Moya.Task {
        // 동일한 task는 한 case로 처리할 수 있음
        switch self {
        case .getProfileImage(let page), .getMyPosts(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        case .getProfile, .getReviews, .getMyPostDetail, .getProfileEdit, .deletePost, .getIdolList, .deleteIdol, .postIdol:
            return .requestPlain
        case .patchProfile(let profileData):
            return .requestJSONEncodable(profileData)
        case .postProfileImage(let profileImage):
            return .uploadMultipart(profileImage)
        case .getSearchIdol(keyword: let keyword):
            return .requestParameters(parameters: ["keyword" : keyword], encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        default :
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \("eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwiaWF0IjoxNzM5NjA1MTI5LCJleHAiOjE3Mzk2MDg3Mjl9.rA5Src5qxLQLGsFDG7Wae6KGSVaXqIzJPhtanxiUHRs")"]
        }
    }
}
