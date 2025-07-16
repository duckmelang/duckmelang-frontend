//
//  ReportService.swift
//  Duckmelang
//
//  Created by nau on 7/15/25.
//

import Foundation
import Moya

public final class ReportService : NetworkManager {
    typealias Endpoint = ReportEndpoint
    
    // MARK: - Provider 설정
    let provider: MoyaProvider<ReportEndpoint>
    
    public init(provider: MoyaProvider<ReportEndpoint>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            TokenPlugin(),
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<ReportEndpoint>(plugins: plugins)
    }
    
    //MARK: - API funcs
    public func postReport(request: ReportRequest) async throws {
        try await requestAsync(target: .postReport(request: request))
    }
}
