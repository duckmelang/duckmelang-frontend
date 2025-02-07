//
//  MyPageResponse.swift
//  Duckmelang
//
//  Created by 주민영 on 2/3/25.
//

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
    
    /*var localizedGender: String {
        return gender.lowercased() == "male" ? "남성" : "여성"
    }*/
}

// 리뷰 데이터 구조체
public struct myReviewDTO: Codable {
    let reviewID: Int
    let nickname: String
    let gender: String
    let age: Int
    let content: String
    let score: Int
    
    /*var localizedGender: String {
        return gender.lowercased() == "male" ? "남성" : "여성"
    }*/
}

// API 응답 구조체 (리뷰 리스트 포함)
public struct ReviewResponse: Codable {
    let average: Double
    let myReviewList: [myReviewDTO] //리뷰 목록
}
