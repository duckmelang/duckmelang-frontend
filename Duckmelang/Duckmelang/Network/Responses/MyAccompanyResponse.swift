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
    public let createdAt: String
    public let postImageUrl: String?
    public let latestPublicMemberProfileImage: String?
}

// 게시글 받아오는 구조체
public struct PostResponse: Codable {
    let postList: [PostDTO]
    let listSize: Int
    let totalPage: Int
    let totalElements: Int
    let isFirst: Bool
    let isLast: Bool
    let currentPage: Int
}

// 스크랩 목록 정보 담는 구조체
public struct BookmarkItem: Codable {
    let bookmarkId: Int
    let post: PostDTO
}

// 스크랩 목록 받아오는 구조체
public struct BookmarksResponse: Codable {
    let bookmarkList: [BookmarkItem]
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
    let applicationList: [RequestDTO]
    let listSize: Int
    let totalPage: Int
    let totalElements: Int
    let isFirst: Bool
    let isLast: Bool
}

// 수락, 거절 성공 시 받아오는 구조체
public struct AcceptRequestResponse: Codable {
    let mateRelationshipId: Int
    let createdAt: String
}
