//
//  NotificationResponse.swift
//  Duckmelang
//
//  Created by 주민영 on 2/20/25.
//

struct NotificationModel: Codable {
    let id: Int
    let content: String
    let isRead: Bool
    let type: String
    let extraData: String
    let createdAt: String
}

struct NotificationResponse: Codable {
    let notificationList: [NotificationModel]
}
