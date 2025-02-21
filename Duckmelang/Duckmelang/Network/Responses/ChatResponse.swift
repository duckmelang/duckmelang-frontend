//
//  MessageResponse.swift
//  Duckmelang
//
//  Created by 주민영 on 2/13/25.
//

import Foundation

public struct MessageDTO: Codable {
    public let id: String
    public let chatRoomId: Int
    public let senderId: Int
    public let receiverId: Int
    public let messageType: String
    public let text: String?
    public let imageUrls: String?
    public let fileUrl: String?
    public let createdAt: String
}

public struct MessageResponse: Codable {
    public let chatMessageList: [MessageDTO]
    public let hasNext: Bool
    public let lastMessageId: String
}

public struct ChatDTO: Codable {
    public let chatRoomId: Int
    public let oppositeId: Int
    public let oppositeNickname: String
    public let oppositeProfileImage: String
    public let postId: Int
    public let postTitle: String
    public let postImage: String
    public let status: String
    public let lastMessage: String?
    public let lastMessageTime: String
}

public struct ChatResponse: Codable {
    let chatRoomList: [ChatDTO]
    let listSize: Int
    let totalPage: Int
    let totalElements: Int
    let isFirst: Bool
    let isLast: Bool
}

public struct DetailChatroomResponse: Codable {
    let oppositeId: Int
    let oppositeNickname: String
    let oppositeProfileImage: String
    let postId: Int
    let postTitle: String
    let postImage: String
    let chatRoomStatus: String?
    let applicationStatus: String?
    let applicationId: Int
    let reviewId: Int
    let postOwner: Bool
}

public struct MyPageReponse: Codable {
    let memberId: Int
    let nickname: String
    let gender: String
    let age: Int
    let latestPublicMemberProfileImage: String
}
