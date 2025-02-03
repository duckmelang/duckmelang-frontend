//
//  Response.swift
//  Duckmelang
//
//  Created by 주민영 on 1/28/25.
//

import Foundation

// 후기 작성에 필요한 구조체
public struct ReviewDTO: Codable {
    public let score: Double
    public let content: String
    public let receiverId: Int
    public let applicationId: Int
}

// 후기글 작성 페이지에서 보여주는 정보 구조체
public struct ReviewInformation: Codable {
    public let applicationId: Int
    public let name: String
    public let title: String
    public let eventCategory: String
    public let date: String
    public let postImageUrl: String
    public let latestPublicMemberProfileImage: String
}

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

//내 프로필 수정
public struct EditProfileRequest: Codable {
    let memberProfileImageURL: String
    let nickname: String
    let introduction: String
}

// 리뷰 데이터 구조체
public struct ReviewDTO: Codable {
    let reviewID: Int
    let nickname: String
    let gender: String
    let age: Int
    let content: String
    let score: Int
}

// API 응답 구조체 (리뷰 리스트 포함)
public struct ReviewResponse: Codable {
    let average: Double
    let reviewList: [ReviewDTO] //리뷰 목록
}
