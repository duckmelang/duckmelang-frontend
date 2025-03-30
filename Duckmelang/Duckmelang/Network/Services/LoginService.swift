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
            TokenPlugin(),
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<LoginEndpoint>(plugins: plugins)
    }
    
    //MARK: - API funcs
    /// 토큰 재발급 API
    public func postRefreshToken(refreshToken: RefreshTokenRequest) async throws -> RefreshTokenResponseResult {
        return try await requestAsync(target: .postRefreshToken(refreshToken: refreshToken), decodingType: RefreshTokenResponseResult.self)
    }
    
    /// 로그아웃 API
    public func postLogout() async throws -> String {
        return try await requestAsync(target: .postLogout, decodingType: String.self)
    }
    
    /// 로그인 API
    public func postLogin(login: LoginRequest) async throws -> LoginResult {
        return try await requestAsync(target: .postLogin(login: login), decodingType: LoginResult.self)
    }
    
    /// 카카오 로그인 API
    public func kakaoLogin() async throws -> SocialLoginResult {
        return try await requestAsync(target: .kakaoLogin, decodingType: SocialLoginResult.self)
    }
    
    /// 구글 로그인 API
    public func googleLogin() async throws -> SocialLoginResult {
        return try await requestAsync(target: .googleLogin, decodingType: SocialLoginResult.self)
    }
    
    /// 카카오 토큰 API
//    public func getOAuthTokenKakao(memberId: Int) async throws -> SocialLoginResult {
//        return try await requestAsync(target: .getOAuthTokenKakao(memberId: memberId), decodingType: SocialLoginResult.self)
//    }
    
    /// 구글 토큰 API
//    public func getOAuthTokenGoogle(memberId: Int) async throws -> SocialLoginResult {
//        return try await requestAsync(target: .getOAuthTokenGoogle(memberId: memberId), decodingType: SocialLoginResult.self)
//    }
    
    /// 인증번호 전송 API
    public func postSendVerificationCode(phoneNum: VerificationCodeRequest) async throws -> String {
        return try await requestAsync(target: .postSendVerificationCode(phoneNum: phoneNum), decodingType: String.self)
    }
    
    /// 인증번호 인증 API
    public func postVerifyCode(verifyCode: VerifyCode) async throws -> String {
        return try await requestAsync(target: .postVerifyCode(verifyCode: verifyCode), decodingType: String.self)
    }
}
