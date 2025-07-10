//
//  Untitled.swift
//  Duckmelang
//
//  Created by nau on 4/4/25.
//
import Foundation
import Moya

public final class MyPageService : NetworkManager {
    typealias Endpoint = MyPageEndpoint
    
    // MARK: - Provider 설정
    let provider: MoyaProvider<MyPageEndpoint>
    
    public init(provider: MoyaProvider<MyPageEndpoint>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            TokenPlugin(),
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<MyPageEndpoint>(plugins: plugins)
    }
    
    //MARK: - API funcs
    //fetch할때도 쓰는데 이땐 decodingType이 ProfileEditInfoResponse임.. 그래서 아래에 하나 더!
    public func getProfile() async throws -> ProfileData {
        return try await requestAsync(target: .getProfile, decodingType: ProfileData.self)
    }
    
    public func getLatestProfile() async throws -> ProfileEditInfoResponse {
        return try await requestAsync(target: .getLatestProfile, decodingType: ProfileEditInfoResponse.self)
    }

    public func patchProfile(profileData: EditProfileRequest) async throws -> PatchProfileResponse {
        return try await requestAsync(target: .patchProfile(profileData: profileData), decodingType: PatchProfileResponse.self)
    }

    public func getMyPosts(page: Int) async throws -> PostResponse {
        return try await requestAsync(target: .getMyPosts(page: page), decodingType: PostResponse.self)
    }

    public func getReviews() async throws -> ReviewResponse {
        return try await requestAsync(target: .getReviews, decodingType: ReviewResponse.self)
    }

    public func getMyPostDetail(postId: Int) async throws -> MyPostDetailResponse {
        return try await requestAsync(target: .getMyPostDetail(postId: postId), decodingType: MyPostDetailResponse.self)
    }

    public func postProfileImage(profileImage: [MultipartFormData]) async throws -> ProfileImageData {
        try await requestAsync(target: .postProfileImage(profileImage: profileImage), decodingType: ProfileImageData.self)
    }

    //delete는 return 없앰..
    public func deletePost(postId: Int) async throws  {
        try await requestAsync(target: .deletePost(postId: postId))
    }

    public func getIdolList() async throws -> idolListResponse {
        return try await requestAsync(target: .getIdolList, decodingType: idolListResponse.self)
    }

    public func getSearchIdol(keyword: String) async throws -> idolListResponse {
        return try await requestAsync(target: .getSearchIdol(keyword: keyword), decodingType: idolListResponse.self)
    }

    public func postIdol(idolId: Int) async throws -> IdolListDTO {
        return try await requestAsync(target: .postIdol(idolId: idolId), decodingType: IdolListDTO.self)
    }

    public func deleteIdol(idolId: Int) async throws {
        try await requestAsync(target: .deleteIdol(idolId: idolId))
    }

    public func getLandmines() async throws -> LandmineResponse {
        return try await requestAsync(target: .getLandmines, decodingType: LandmineResponse.self)
    }

    public func postLandmines(content: String) async throws -> LandmineModel {
        try await requestAsync(target: .postLandmines(content: content), decodingType: LandmineModel.self)
    }

    public func deleteLandmines(landmineId: Int) async throws {
        try await requestAsync(target: .deleteLandmines(landmineId: landmineId))
    }

    public func getFilters() async throws -> FilterRequest {
        return try await requestAsync(target: .getFilters, decodingType: FilterRequest.self)
    }

    public func postFilters(FilterRequest: FilterRequest) async throws -> FilterResponse {
        try await requestAsync(target: .postFilters(FilterRequest: FilterRequest), decodingType: FilterResponse.self)
    }

    public func patchPostStatus(postId: Int, wanted: Int) async throws -> UpdatePostStatusResponse {
        return try await requestAsync(target: .patchPostStatus(postId: postId, wanted: wanted), decodingType: UpdatePostStatusResponse.self)
    }

    public func patchNotificationsSetting(_ parameters: [String: Bool]) async throws -> NotificationsSettingResponse {
        return try await requestAsync(target: .patchNotificationsSetting(parameters), decodingType: NotificationsSettingResponse.self)
    }

    public func getNotificationsSetting() async throws -> NotificationsSettingResponse {
        return try await requestAsync(target: .getNotificationsSetting, decodingType: NotificationsSettingResponse.self)
    }

    public func getMyPageLogin() async throws -> myPageLoginResponse {
        return try await requestAsync(target: .getMyPageLogin, decodingType: myPageLoginResponse.self)
    }

    public func getMyProfileImage(page: Int) async throws -> myProfileImageResponse {
        return try await requestAsync(target: .getMyProfileImage(page: page), decodingType: myProfileImageResponse.self)
    }

    public func deleteAccount() async throws {
        try await requestAsync(target: .deleteAccount)
    }
    
    public func patchProfileImageStatus(imageId: Int, publicStatus: Bool) async throws -> ProfileImageStatusResponse {
        try await requestAsync(target: .patchProfileImageStatus(imageId: imageId, publicStatus: publicStatus), decodingType: ProfileImageStatusResponse.self)
    }
}
