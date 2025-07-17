//
//  HomeService.swift
//  Duckmelang
//
//  Created by 주민영 on 3/27/25.
//

import Foundation
import Moya

public final class HomeService : NetworkManager {
    typealias Endpoint = HomeEndpoint
    
    // MARK: - Provider 설정
    let provider: MoyaProvider<HomeEndpoint>
    
    public init(provider: MoyaProvider<HomeEndpoint>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            TokenPlugin(),
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<HomeEndpoint>(plugins: plugins)
    }
    
    //MARK: - API funcs
    /// 전체 게시글 조회 API
    public func getAllPosts(page: Int) async throws -> PostResponse {
        return try await requestAsync(target: .getAllPosts(page: page), decodingType: PostResponse.self)
    }
    
    /// 아이돌 별 게시글 조회 API
    public func getIdolPosts(idolId: Int, page: Int) async throws -> PostResponse {
        return try await requestAsync(target: .getIdolPosts(idolId: idolId, page: page), decodingType: PostResponse.self)
    }
    
    /// 아이돌 목록 API
    public func getIdols() async throws -> idolResponse {
        return try await requestAsync(target: .getIdols, decodingType: idolResponse.self)
    }
    
    /// 이벤트 목록 API
    public func getEvents() async throws -> EventResponse {
        return try await requestAsync(target: .getEvents, decodingType: EventResponse.self)
    }
    
    /// 게시글 생성 API
    public func postPosts(formData: [MultipartFormData]) async throws -> WrtieResponse {
        return try await requestAsync(target: .postPosts(formData: formData), decodingType: WrtieResponse.self)
    }
    
    /// 게시글 수정
    public func patchPosts(postId: Int, formData: [MultipartFormData]) async throws -> WrtieResponse {
        return try await requestAsync(target: .patchPosts(postId: postId, formData: formData), decodingType: WrtieResponse.self)
    }
    
    /// 스크랩 API
    public func postBookmark(postId: Int) async throws -> BookmarkResult {
        return try await requestAsync(target: .postBookmark(postId: postId), decodingType: BookmarkResult.self)
    }
    
    public func deleteBookmark(postId: Int) async throws {
        try await requestAsync(target: .deleteBookmark(postId: postId))
    }
    
    /// 알림 목록 API
    public func getNotifications() async throws -> NotificationResponse {
        return try await requestAsync(target: .getNotifications, decodingType: NotificationResponse.self)
    }
    
    /// 알림 읽음 처리 API
    public func patchNotifications(notificationId: Int) async throws -> ReadResponse {
        return try await requestAsync(target: .patchNotifications(notificationId: notificationId), decodingType: ReadResponse.self)
    }
    
    /// 알림 삭제 API
    public func deleteNotifications(notificationId: Int) async throws -> String {
        return try await requestAsync(target: .deleteNotifications(notificationId: notificationId), decodingType: String.self)
    }
    
    /// 검색 API
    public func getSearch(page: Int, searchKeyword: String) async throws -> PostResponse {
        return try await requestAsync(target: .getSearch(page: page, searchKeyword: searchKeyword), decodingType: PostResponse.self)
    }
    
    /// 필터 검색 API
    public func searchPosts(page: Int, keyword: String, gender: String?, minAge: Int?, maxAge: Int?) async throws -> PostResponse {
        return try await requestAsync(target: .searchPosts(page: page, keyword: keyword, gender: gender, minAge: minAge, maxAge: maxAge), decodingType: PostResponse.self)
    }
    
    /// 필터 조회 API
    public func getFilters() async throws -> FilterResponse {
        return try await requestAsync(target: .getFilters, decodingType: FilterResponse.self)
    }
}
