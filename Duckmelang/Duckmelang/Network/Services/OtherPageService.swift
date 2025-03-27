//
//  OtherPageService.swift
//  Duckmelang
//
//  Created by 주민영 on 3/26/25.
//

import Foundation
import Moya

public final class OtherPageService : NetworkManager {
    typealias Endpoint = OtherPageEndpoint
    
    // MARK: - Provider 설정
    let provider: MoyaProvider<OtherPageEndpoint>
    
    public init(provider: MoyaProvider<OtherPageEndpoint>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            TokenPlugin(),
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<OtherPageEndpoint>(plugins: plugins)
    }
    
    //MARK: - API funcs
    /// 상대 정보 API
    public func getOtherProfile(memberId: Int) async throws -> OtherProfileData {
        return try await requestAsync(target: .getOtherProfile(memberId: memberId), decodingType: OtherProfileData.self)
    }
    
    /// 상대 프로필 이미지 API
    public func getOtherProfileImage(memberId: Int, page: Int) async throws -> OtherImageResponse {
        return try await requestAsync(target: .getOtherProfileImage(memberId: memberId, page: page), decodingType: OtherImageResponse.self)
    }
    
    /// 상대 게시글 API
    public func getOtherPosts(memberId: Int, page: Int) async throws -> PostResponse {
        return try await requestAsync(target: .getOtherPosts(memberId: memberId, page: page), decodingType: PostResponse.self)
    }
    
    /// 상대 후기 API
    public func getOtherReviews(memberId: Int) async throws -> OtherReviewResponse {
        return try await requestAsync(target: .getOtherReviews(memberId: memberId), decodingType: OtherReviewResponse.self)
    }
    
    /// 후기 생성 함수
    public func makeReview(score: Double, content: String, receiverId: Int, applicationId: Int) -> ReviewRequest {
        return ReviewRequest(
            score: score,
            content: content,
            receiverId: receiverId,
            applicationId: applicationId
        )
    }
    
    /// 후기 생성 API
    public func postReviews(reviewData: ReviewRequest)async throws -> PostReviewResponse {
        return try await requestAsync(target: .postReviews(reviewData: reviewData), decodingType: PostReviewResponse.self)
    }
    
    /// 후기 정보 가져오기 API
    public func getReviewsInformation(memberId: Int, postId: Int) async throws -> ReviewInformation {
        return try await requestAsync(target: .getReviewsInformation(memberId: memberId, postId: postId), decodingType: ReviewInformation.self)
    }
}
