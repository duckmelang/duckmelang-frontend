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
    case getMessages(chatRoomId: Int, lastMessageId: String?, size: Int)
    
    case postRequest(postId: Int)
    
    case getMemberId // 채팅 보내기에서 멤버아이디를 가져오기 위해서
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
        case .postRequest:
            guard let url = URL(string: API.requestURL) else {
                fatalError("requestURL 오류")
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
        case .getDetailChatroom:
            return "/{chatRoomId}"
        case .getMessages(let chatRoomId, _, _):
            return "/chat/\(chatRoomId)/messages"
        case .postRequest(let postId):
            return "/send/\(postId)"
        case .getMemberId:
            return "/mypage"
        }
    }
    
    public var method: Moya.Method {
        // 가장 많이 호출되는 get을 default로 처리하기
        // 동일한 method는 한 case로 처리할 수 있음
        switch self {
        case .postRequest:
            return .post
        default:
            return .get
        }
    }
    
    public var task: Moya.Task {
        // 동일한 task는 한 case로 처리할 수 있음
        switch self {
        case .getChatrooms(let page), .getOngoingChatrooms(let page), .getTerminatedChatrooms(let page), .getConfirmedChatrooms(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        case .getDetailChatroom(let chatRoomId):
            return .requestParameters(parameters: ["chatRoomId": chatRoomId], encoding: URLEncoding.queryString)
        case .getMessages(_, let lastMessageId, let size):
            var params: [String: Any] = ["size": size]
            if let lastMessageId = lastMessageId {
                params["lastMessageId"] = lastMessageId
            }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .postRequest, .getMemberId:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        default :
            return [
                "Content-Type": "application/json"
            ]
        }
    }
}
