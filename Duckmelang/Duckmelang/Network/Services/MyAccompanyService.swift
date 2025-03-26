//
//  MyAccompanyService.swift
//  Duckmelang
//
//  Created by 주민영 on 3/26/25.
//

import Foundation
import Moya

public final class MyAccompanyService : NetworkManager {
    typealias Endpoint = MyAccompanyEndpoint
    
    // MARK: - Provider 설정
    let provider: MoyaProvider<MyAccompanyEndpoint>
    
    public init(provider: MoyaProvider<MyAccompanyEndpoint>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            TokenPlugin(),
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<MyAccompanyEndpoint>(plugins: plugins)
    }
    
    //MARK: - API funcs
    /// 대기중 요청 API
    public func getPendingRequests(page: Int) async throws -> RequestResponse {
        return try await requestAsync(target: .getPendingRequests(page: page), decodingType: RequestResponse.self)
    }
    
    /// 보낸 요청 API
    public func getSentRequests(page: Int) async throws -> RequestResponse {
        return try await requestAsync(target: .getSentRequests(page: page), decodingType: RequestResponse.self)
    }
    
    /// 받은 요청 API
    public func getReceivedRequests(page: Int) async throws -> RequestResponse {
        return try await requestAsync(target: .getReceivedRequests(page: page), decodingType: RequestResponse.self)
    }
    
    /// 요청 수락  API
    public func postRequestSucceed(applicationId: Int) async throws -> String {
        return try await requestAsync(target: .postRequestSucceed(applicationId: applicationId), decodingType: String.self)
    }
    
    /// 요청 거절  API
    public func postRequestFailed(applicationId: Int) async throws -> String {
        return try await requestAsync(target: .postRequestFailed(applicationId: applicationId), decodingType: String.self)
    }
    
    /// 스크랩  API
    public func getBookmarks(page: Int) async throws -> PostResponse {
        return try await requestAsync(target: .getBookmarks(page: page), decodingType: PostResponse.self)
    }
    
    /// 내 게시물  API
    public func getMyPosts(page: Int) async throws -> PostResponse {
        return try await requestAsync(target: .getMyPosts(page: page), decodingType: PostResponse.self)
    }
    
    /// 게시물 상세정보  API
    public func getPostDetail(postId: Int) async throws -> MyPostDetailResponse {
        return try await requestAsync(target: .getPostDetail(postId: postId), decodingType: MyPostDetailResponse.self)
    }
}
