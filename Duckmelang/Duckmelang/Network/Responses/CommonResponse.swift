//
//  CommonReponse.swift
//  Duckmelang
//
//  Created by 주민영 on 1/29/25.
//

import Foundation

// 최상위 응답 모델
public struct ApiResponse<T: Decodable>: Decodable {
    public let isSuccess: Bool
    public let code: String
    public let message: String
    public let result: T?
}

/// API 사용법
//private let provider = MoyaProvider<AllEndpoint>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
//
//private func getMyPostsAPI() {
//    provider.request(.getMyPosts(memberId: 1, page: 0)) { result in
//        switch result {
//        case .success(let response):
//            let response = try? response.map(ApiResponse<MyPostResponse>.self)
//            guard let result = response?.result?.postList else { return }
//            print(result)
//        case .failure(let error):
//            print(error)
//        }
//    }
//}
