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
