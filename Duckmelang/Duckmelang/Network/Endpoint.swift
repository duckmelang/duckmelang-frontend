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
    case sendVerificationCode(phoneNumber: String)
    case verifyCode(phoneNumber: String, code: String)
    case login(email: String, password: String)
    case signUp(email: String, password: String)
    case getMyPosts(memberId: Int, page: Int)
    case getBookmarks(memberId: Int, page: Int)
    
    case getPendingRequests(memberId: Int, page: Int)
    case getSentRequests(memberId: Int, page: Int)
    case getReceivedRequests(memberId: Int, page: Int)
    
    case getProfileImage(memberId: Int, page: Int)
    case kakaoLogin
    case googleLogin
    case getProfile(memberId: Int) // 프로필 조회 API 추가
    case EditProfile(profileData: EditProfileRequest)
}

extension AllEndpoint: TargetType {
    public var baseURL: URL {
        switch self {
        case .postReviews(_, _), .getReviewsInformation(_, _):
            guard let url = URL(string: API.reviewURL) else {
                fatalError("reviewURL 오류")
            }
            return url
        case .getPendingRequests(_, _), .getSentRequests(_, _), .getReceivedRequests(_, _):
            guard let url = URL(string: API.requestURL) else {
                fatalError("requestURL 오류")
            }
            return url
        case .getMyPosts(_, _):
            guard let url = URL(string: API.postURL) else {
                fatalError("postURL 오류")
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
        case .postReviews(_, _):
            return ""
        case .getReviewsInformation(_, _):
            return "/information"
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
        case .getPendingRequests(_, _):
            return "/received/pending"
        case .getSentRequests(_, _):
            return "/sent"
        case .getReceivedRequests(_, _):
            return "/received"
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
        case .postReviews(_, _):
            return .post
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
        case .postReviews(let memberId, let reviewData):
            guard let jsonData = try? JSONEncoder().encode(reviewData) else {
                return .requestPlain
            }
            return .requestCompositeData(bodyData: jsonData, urlParameters: ["memberId": memberId])
        case .getReviewsInformation(let memberId, let myId):
            return .requestParameters(parameters: ["memberId": memberId, "myId": myId], encoding: URLEncoding.queryString)
        case .getMyPosts(let memberId, let page), .getPendingRequests(let memberId, let page), .getSentRequests(let memberId, let page), .getReceivedRequests(let memberId, let page), .getProfileImage(let memberId, let page):
            return .requestParameters(parameters: ["memberId": memberId, "page": page], encoding: URLEncoding.queryString)
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

