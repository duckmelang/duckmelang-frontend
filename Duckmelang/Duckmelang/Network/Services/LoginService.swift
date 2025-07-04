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
    
    /// 로그인 API
    public func postLogin(login: LoginRequest) async throws -> LoginResult {
        return try await requestAsync(target: .postLogin(login: login), decodingType: LoginResult.self)
    }
}
