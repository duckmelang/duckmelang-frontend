//
//  Response.swift
//  Duckmelang
//
//  Created by 주민영 on 1/28/25.
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
    public let postImageUrl: String
    public let latestPublicMemberProfileImage: String
}

public struct PostResponse: Codable {
    let postList: [PostDTO]
    let listSize: Int
    let totalPage: Int
    let totalElements: Int
    let isFirst: Bool
    let isLast: Bool
}

//프로필 정보 담는 구조체
public struct ProfileData: Codable {
    let memberId: Int
    let nickname: String
    let gender: String
    let age: Int
    let latestPublicMemberProfileImage: String
    let introduction: String
    let postCount: Int
    let succeedApplicationCount: Int
}

//네 프로필 수정
public struct EditProfileRequest: Codable {
    let memberProfileImageURL: String
    let nickname: String
    let introduction: String
}
