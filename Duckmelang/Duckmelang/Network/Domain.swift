//
//  Domain.swift
//  Duckmelang
//
//  Created by 주민영 on 1/28/25.
//

import UIKit

public struct API {
    public static let baseURL = "http://13.125.217.231:8080"
    public static let reviewURL = "\(baseURL)/reviews"
    public static let requestURL = "\(baseURL)/requests"
    public static let loginURL = "\(baseURL)/login"
    public static let oauthURL = "https://13.125.217.231.nip.io/oauth2/authorization"
    public static let oauthCodeURL = "\(loginURL)/oauth2/code"
    public static let postURL = "\(baseURL)/posts"
    public static let smsURL = "\(baseURL)/sms"
    public static let memberURL = "\(baseURL)/members"
    public static let mypageURL = "\(baseURL)/mypage"
    public static let profileURL = "\(baseURL)/profile"
    public static let chatroomURL = "\(baseURL)/chatrooms"
    public static let notificationURL = "\(baseURL)/notifications"
}
