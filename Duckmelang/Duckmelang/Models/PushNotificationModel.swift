//
//  PushNotificationModel.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/30/25.
//

import Foundation

struct PushNotificationModel {
    let title: String
    var isOn: Bool
}

var notifications: [[PushNotificationModel]] = [
    [ // 첫 번째 섹션 (서비스 알림)
        PushNotificationModel(title: "채팅 알림", isOn: false),
        PushNotificationModel(title: "동행 확정 요청 수신 알림", isOn: false),
        PushNotificationModel(title: "후기작성 알림", isOn: false)
    ],
    [ // 두 번째 섹션 (광고성 정보 알림)
        PushNotificationModel(title: "푸시 알림", isOn: false),
        PushNotificationModel(title: "SMS", isOn: false),
        PushNotificationModel(title: "이메일", isOn: false)
    ]
]
