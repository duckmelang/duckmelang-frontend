//
//  MyPageRequest.swift
//  Duckmelang
//
//  Created by 주민영 on 2/3/25.
//

import Foundation

//내 프로필 수정
public struct EditProfileRequest: Codable {
    let nickname: String
    let introduction: String
}

public struct FilterRequest: Codable {
    let gender : String?
    let minAge : Int?
    let maxAge : Int?
}

public struct NotificationsSettingRequest: Codable {
    var chatNotificationEnabled: Bool
    var requestNotificationEnabled: Bool
    var reviewNotificationEnabled: Bool
    var bookmarkNotificationEnabled: Bool
}
