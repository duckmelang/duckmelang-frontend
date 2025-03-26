//
//  NetworkError.swift
//  Duckmelang
//
//  Created by 주민영 on 3/26/25.
//

import Foundation

public enum NetworkError: Error {
    case networkError(devMessage: String, userMessage: String)
    case decodingError(devMessage: String, userMessage: String)
    case serverError(statusCode: Int, devMessage: String, userMessage: String)
    case unknown
    case tokenExpiredError(statusCode: Int, devMessage: String, userMessage: String)
    case refreshTokenExpiredError(statusCode: Int, devMessage: String, userMessage: String)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .networkError(let devMessage, _):
            return devMessage
        case .decodingError(let devMessage, _):
            return devMessage
        case .serverError(let statusCode, let devMessage, _):
            return "[\(statusCode)] \(devMessage)"
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        case .tokenExpiredError(let statusCode, let devMessage, _):
            return "[\(statusCode)] \(devMessage)"
        case .refreshTokenExpiredError(let statusCode, let devMessage, _):
            return "[\(statusCode)] \(devMessage)"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .networkError(_, let userMessage):
            return userMessage
        case .decodingError(_, let userMessage):
            return userMessage
        case .serverError(_, _, let userMessage):
            return "\(userMessage)"
        case .unknown:
            return "관리자에게 문의하세요."
        case .tokenExpiredError(_, _, let userMessage):
            return "\(userMessage)"
        case .refreshTokenExpiredError(_, _, let userMessage):
            return "\(userMessage)"
        }
    }
}

public struct ErrorResponse: Decodable {
    let isSuccess : Bool
    let httpStatus : String
    let code : String
    let message: String
}
