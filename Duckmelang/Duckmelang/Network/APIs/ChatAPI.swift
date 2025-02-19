//
//  ChatAPI.swift
//  Duckmelang
//
//  Created by 주민영 on 2/16/25.
//

import UIKit
import Moya

// 1 명세서 당 1 API enum 정의하기
// case 이름은 반드시 method로 시작하기 !!
// 예) .post~, .patch~, .get~, .delete~
// 매개변수를 사용하지 않는 곳이라면 생략하고 case 이름만 작성해도 됨
// 예) .postReviews(let memberId) : X / .postReviews : O

public enum ChatAPI {
    case getChatrooms(page: Int)
    case getOngoingChatrooms(page: Int)
    case getTerminatedChatrooms(page: Int)
    case getConfirmedChatrooms(page: Int)
    
    case getDetailChatroom(chatRoomId: Int)
    case getMessages(chatRoomId: Int, size: Int)
}

extension ChatAPI: TargetType {
    // Domain.swift 파일 참고해서 맞는 baseURL 적용하기
    // 모두 같은 baseURL을 사용한다면 default로 지정하기
    public var baseURL: URL {
        switch self {
        case .getChatrooms, .getOngoingChatrooms, .getTerminatedChatrooms, .getConfirmedChatrooms,.getDetailChatroom:
            guard let url = URL(string: API.chatroomURL) else {
                fatalError("chatroomURL 오류")
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
        case .getChatrooms:
            return ""
        case .getOngoingChatrooms:
            return "/ongoing"
        case .getTerminatedChatrooms:
            return "/terminated"
        case .getConfirmedChatrooms:
            return "/confirmed"
        case .getDetailChatroom(let chatRoomId):
            return "/\(chatRoomId)"
        case .getMessages(let chatRoomId, _):
            return "/chat/\(chatRoomId)/messages"
        }
    }
    
    public var method: Moya.Method {
        // 가장 많이 호출되는 get을 default로 처리하기
        // 동일한 method는 한 case로 처리할 수 있음
        switch self {
        default:
            return .get
        }
    }
    
    public var task: Moya.Task {
        // 동일한 task는 한 case로 처리할 수 있음
        switch self {
        case .getChatrooms(let page), .getOngoingChatrooms(let page), .getTerminatedChatrooms(let page), .getConfirmedChatrooms(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        case .getDetailChatroom:
            return .requestPlain
        case .getMessages(_, let size):
            return .requestParameters(parameters: ["size": size], encoding: URLEncoding.queryString)
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
