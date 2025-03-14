//
//  MyPageResponse.swift
//  Duckmelang
//
//  Created by 주민영 on 2/3/25.
//
import Foundation
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
    
    var localizedGender: String {
        return gender.lowercased() == "male" ? "남성" : "여성"
    }
    
    var localizedAge: String {
        return "만 \(age)세"
    }
    
    enum CodingKeys: String, CodingKey {
        case memberId
        case nickname
        case gender
        case age
        case latestPublicMemberProfileImage
        case introduction
        case postCount
        case succeedApplicationCount = "matchCount"  // `matchCount` 키와 매핑
    }
}

// 리뷰 데이터 구조체
public struct myReviewDTO: Codable {
    let reviewId: Int
    let nickname: String
    let gender: String
    let age: Int
    let content: String
    let score: Double
    
    var localizedGender: String {
        return gender.lowercased() == "male" ? "남성" : "여성"
    }
    
    var localizedAge: String {
        return "만 \(age)세"
    }
}

// API 응답 구조체 (리뷰 리스트 포함)
public struct ReviewResponse: Codable {
    let average: Double
    let reviewList: [myReviewDTO] //리뷰 목록
}

struct MyPostDetailResponse: Codable {
    let memberId: Int
    let nickname: String
    let age: Int
    let gender: String
    let averageScore: Double
    let bookmarkCount: Int
    let viewCount: Int
    let chatCount: Int
    let title: String
    let content: String
    let wanted: Int
    let idol: [String]
    let category: String
    let date: String
    let createdAt: String
    let postImageUrl: [String]
    let latestPublicMemberProfileImage: String?
    
    var localizedAge: String {
        return "만 \(age)세"
    }
}

struct ProfileImageResponse: Codable {
    let memberProfileImageUrl: String
    let createdAt: String
}

struct ProfileEditInfoResponse: Codable {
    let nickname: String
    let latestPublicMemberProfileImage: String?
}

//현재 관심 아이돌 목록 조회
struct idolListResponse: Codable {
    let idolList: [IdolListDTO]
}

struct IdolListDTO: Codable {
    let idolId: Int
    let idolName: String
    let idolImage: String
}

//get 응답 모델
struct LandmineResponse: Codable {
    let landmineList: [LandmineModel]
}

//post 응답 모델
struct LandmineModel: Codable {
    let landmineId: Int
    let content: String
}

struct UpdatePostStatusResponse: Codable {
    let id: Int
    let title: String
    let wanted: Int
}

struct NotificationsSettingResponse: Codable {
    let notificationSettingId: Int
    let memberId: Int
    var chatNotificationEnabled: Bool
    var requestNotificationEnabled: Bool
    var reviewNotificationEnabled: Bool
    var bookmarkNotificationEnabled: Bool
}

struct myPageLoginResponse: Codable {
    let nickname: String
    let email: String
    var kakaoLinked: Bool
    var googleLinked: Bool
}

public struct myProfileImageResponse: Codable {
    let profileImageList: [ProfileImageData]
    let listSize: Int
    let totalPage: Int
    let totalElements: Int
    let isFirst: Bool
    let isLast: Bool
}

public struct ProfileImageData: Codable {
    let memberProfileImageUrl: String
    let createdAt: String
}
