//
//  ReviewResponse.swift
//  Duckmelang
//
//  Created by 주민영 on 2/3/25.
//

import Foundation

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

// 후기글 작성 성공 후 받아오는 구조체
public struct PostReviewResponse: Codable {
    public let reviewId: Int
    public let score: Double
    public let content: String
    public let receiverId: Int
}
