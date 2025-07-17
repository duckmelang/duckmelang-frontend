//
//  LoginService.swift
//  Duckmelang
//
//  Created by 주민영 on 3/28/25.
//

import Foundation
import Moya

public final class LoginService : NetworkManager {
    typealias Endpoint = LoginEndpoint
    
    // MARK: - Provider 설정
    let provider: MoyaProvider<LoginEndpoint>
    
    public init(provider: MoyaProvider<LoginEndpoint>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<LoginEndpoint>(plugins: plugins)
    }
    
    //MARK: - API funcs
    /// 아이디 중복 확인 API
    public func getCheckNickname(loginId: String) async throws -> CheckResult {
        return try await requestAsync(target: .getCheckNickname(loginId: loginId), decodingType: CheckResult.self)
    }
    
    /// 토큰 재발급 API
    public func postRefreshToken(refreshToken: RefreshTokenRequest) async throws -> RefreshTokenResponseResult {
        return try await requestAsync(target: .postRefreshToken(refreshToken: refreshToken), decodingType: RefreshTokenResponseResult.self)
    }
    
    /// 전화번호 중복 확인 API
    public func getCheckPhoneNum(phoneNum: String) async throws -> CheckResult {
        return try await requestAsync(target: .getCheckPhoneNum(phoneNum: phoneNum), decodingType: CheckResult.self)
    }
    
    /// 로그인 API
    public func postLogin(login: LoginRequest) async throws -> LoginResult {
        return try await requestAsync(target: .postLogin(login: login), decodingType: LoginResult.self)
    }
    
    /// 비밀번호 변경 API
    public func patchPassword(login: NewPasswordRequest) async throws -> String {
        return try await requestAsync(target: .patchPassword(login: login), decodingType: String.self)
    }
    
    /// 아이디 찾기 API
    public func getFindId(phoneNum: String) async throws -> FindIdResult {
        return try await requestAsync(target: .getFindId(phoneNum: phoneNum), decodingType: FindIdResult.self)
    }
    
    /// 카카오 로그인 API
    public func kakaoLogin(accessToken: KakaoLoginRequest) async throws -> LoginResult {
        return try await requestAsync(target: .kakaoLogin(accessToken: accessToken), decodingType: LoginResult.self)
    }
}
