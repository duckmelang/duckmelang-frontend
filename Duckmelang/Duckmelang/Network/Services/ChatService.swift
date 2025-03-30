//
//  ChatService.swift
//  Duckmelang
//
//  Created by 주민영 on 3/26/25.
//

import Foundation
import Moya

public final class ChatService : NetworkManager {
    typealias Endpoint = ChatEndpoint
    
    // MARK: - Provider 설정
    let provider: MoyaProvider<ChatEndpoint>
    
    public init(provider: MoyaProvider<ChatEndpoint>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            TokenPlugin(),
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<ChatEndpoint>(plugins: plugins)
    }
    
    //MARK: - API funcs
    /// 전체 채팅방 API
    public func getChatrooms(page: Int) async throws -> ChatResponse {
        return try await requestAsync(target: .getChatrooms(page: page), decodingType: ChatResponse.self)
    }
    
    /// 진행중 채팅방 API
    public func getOngoingChatrooms(page: Int) async throws -> ChatResponse {
        return try await requestAsync(target: .getOngoingChatrooms(page: page), decodingType: ChatResponse.self)
    }
    
    /// 동행확정 채팅방 API
    public func getConfirmedChatrooms(page: Int) async throws -> ChatResponse {
        return try await requestAsync(target: .getConfirmedChatrooms(page: page), decodingType: ChatResponse.self)
    }
    
    /// 종료 채팅방 API
    public func getTerminatedChatrooms(page: Int) async throws -> ChatResponse {
        return try await requestAsync(target: .getTerminatedChatrooms(page: page), decodingType: ChatResponse.self)
    }
    
    /// 채팅방 상세정보 불러오기 API
    public func getDetailChatroom(chatRoomId: Int) async throws -> DetailChatroomResponse {
        return try await requestAsync(target: .getDetailChatroom(chatRoomId: chatRoomId), decodingType: DetailChatroomResponse.self)
    }
    
    /// 이전 메세지 불러오기 API
    public func getMessages(chatRoomId: Int, lastMessageId: String?, size: Int) async throws -> MessageResponse {
        return try await requestAsync(target: .getMessages(chatRoomId: chatRoomId, lastMessageId: lastMessageId, size: size), decodingType: MessageResponse.self)
    }
    
    /// 동행 요청 API
    public func postRequest(postId: Int) async throws -> PostRequestResponse {
        return try await requestAsync(target: .postRequest(postId: postId), decodingType: PostRequestResponse.self)
    }
}
