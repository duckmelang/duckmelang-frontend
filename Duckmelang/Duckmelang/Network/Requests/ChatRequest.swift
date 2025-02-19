//
//  MessageRequest.swift
//  Duckmelang
//
//  Created by 주민영 on 2/13/25.
//

import Foundation

public struct MessageRequest: Codable {
    public let senderId: Int
    public let receiverId: Int
    public let postId: Int
    public let messageType: String
    public let text: String
}

public struct ReceivedMessage: Codable {
    public let senderId: Int
    public let receiverId: Int
    public let postId: Int
    public let messageType: String
    public let text: String?        // 텍스트 메시지일 경우 값이 있음
    public let imageUrls: [String]? // 이미지 메시지일 경우 값이 있음
    public let fileUrl: String?     // 파일 메시지일 경우 값이 있음
}
