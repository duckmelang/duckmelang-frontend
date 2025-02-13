//
//  MyAccompanyResponse.swift
//  Duckmelang
//
//  Created by 주민영 on 2/3/25.
//

import Foundation

// 게시글 정보를 담는 구조체
public struct PostDTO: Codable {
    public let postId: Int
    public let title: String
    public let category: String
    public let date: String
    public let nickname: String
    public let createdAt: String?
    public let postImageUrl: String
    public let latestPublicMemberProfileImage: String
}

// 게시글 받아오는 구조체
public struct PostResponse: Codable {
    let postList: [PostDTO]
    let listSize: Int
    let totalPage: Int
    let totalElements: Int
    let isFirst: Bool
    let isLast: Bool
}

// 보낸 요청 정보를 담는 구조체
public struct RequestDTO: Codable {
    public let postId: Int
    public let postTitle: String
    public let postImage: String
    public let oppositeNickname: String
    public let oppositeProfileImage: String
    public let applicationId: Int
    public let applicationCreatedAt: String
    public let applicationStatus: String
}

// 보낸 요청 받아오는 구조체
public struct RequestResponse: Codable {
    let requestApplicationList: [RequestDTO]
    let listSize: Int
    let totalPage: Int
    let totalElements: Int
    let isFirst: Bool
    let isLast: Bool
}
