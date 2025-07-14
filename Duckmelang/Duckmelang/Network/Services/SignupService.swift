//
//  SignupService.swift
//  Duckmelang
//
//  Created by 주민영 on 3/28/25.
//

import Foundation
import Moya

public final class SignupService : NetworkManager {
    typealias Endpoint = SignupEndpoint
    
    // MARK: - Provider 설정
    let provider: MoyaProvider<SignupEndpoint>
    
    public init(provider: MoyaProvider<SignupEndpoint>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<SignupEndpoint>(plugins: plugins)
    }
    
    //MARK: - API funcs
    /// 아이디 중복 확인 API
    public func getCheckNickname(loginId: String) async throws -> CheckResult {
        return try await requestAsync(target: .getCheckNickname(loginId: loginId), decodingType: CheckResult.self)
    }
    
    /// 회원가입 API
    public func postSignUp(signUp: SignupRequest) async throws -> SignupResponseResult {
        return try await requestAsync(target: .postSignUp(signUp: signUp), decodingType: SignupResponseResult.self)
    }

    /// 닉네임, 생년월일, 성별 설정 API
    public func patchMemberProfile(memberId: Int, profile: PatchMemberProfileRequest) async throws -> MemberProfile {
        return try await requestAsync(target: .patchMemberProfile(memberId: memberId, profile: profile), decodingType: MemberProfile.self)
    }

    /// 프로필 사진 설정 API
    public func postMemberProfileImage(memberId: Int, profileImage: [MultipartFormData]) async throws -> MemberProfileImage {
        return try await requestAsync(target: .postMemberProfileImage(memberId: memberId, profileImage: profileImage), decodingType: MemberProfileImage.self)
    }

    /// 닉네임 중복 확인 API
    public func getMemberNicknameCheck(nickname: String) async throws -> NicknameCheckResult {
        return try await requestAsync(target: .getMemberNicknameCheck(nickname: nickname), decodingType: NicknameCheckResult.self)
    }

    /// 덕질하는 아이돌 설정 API
    public func postMemberInterestCeleb(memberId: Int, idolNums: SelectFavoriteIdolRequest) async throws -> MemberIdol {
        return try await requestAsync(target: .postMemberInterestCeleb(memberId: memberId, idolNums: idolNums), decodingType: MemberIdol.self)
    }

    /// 관심있는 행사 종류 선택 API
    public func postMemberInterestEvent(memberId: Int, eventNums: SelectFavoriteEventRequest) async throws -> MemberEvent {
        return try await requestAsync(target: .postMemberInterestEvent(memberId: memberId, eventNums: eventNums), decodingType: MemberEvent.self)
    }

    /// 지뢰 설정 API
    public func postLandMines(memberId: Int, landmineString: SetLandmineKeywordRequest) async throws -> LandmineResult {
        return try await requestAsync(target: .postLandMines(memberId: memberId, landmineString: landmineString), decodingType: LandmineResult.self)
    }

    /// 모든 아이돌 리스트 조회 API
    public func getAllIdols() async throws -> IdolListResult {
        return try await requestAsync(target: .getAllIdols, decodingType: IdolListResult.self)
    }

    /// 아이돌 검색 조회 API
    public func getSearchIdol(keyword: String) async throws -> IdolListResult {
        return try await requestAsync(target: .getSearchIdol(keyword: keyword), decodingType: IdolListResult.self)
    }

    /// 모든 행사 리스트 조회 API
    public func getAllEvents() async throws -> EventResponse {
        return try await requestAsync(target: .getAllEvents, decodingType: EventResponse.self)
    }

}

