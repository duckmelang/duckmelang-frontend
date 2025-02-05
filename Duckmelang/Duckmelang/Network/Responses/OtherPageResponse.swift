//
//  OtherPageResponse.swift
//  Duckmelang
//
//  Created by 주민영 on 2/5/25.
//

//프로필 정보 담는 구조체
public struct OtherProfileData: Codable {
    let nickname: String
    let gender: String
    let age: Int
    let introduction: String
    let profileImageUrl: String
    let postCnt: Int
    let matchCnt: Int
}

// 전체 프로필 이미지 받아오는 구조체
public struct OtherImageResponse: Codable {
    let profileImageList: [OtherImageData]
    let listSize: Int
    let totalPage: Int
    let totalElements: Int
    let isFirst: Bool
    let isLast: Bool
}

public struct OtherImageData:Codable {
    let imageId: Int
    let publicStatus: Bool
}

// 리뷰 데이터 구조체
public struct OtherReviewDTO: Codable {
    let reviewID: Int
    let nickname: String
    let gender: String
    let age: Int
    let content: String
    let score: Int
}

// API 응답 구조체 (리뷰 리스트 포함)
public struct OtherReviewResponse: Codable {
    let average: Double
    let reviewList: [OtherReviewDTO] //리뷰 목록
}
