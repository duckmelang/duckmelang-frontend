//
//  NetworkManager+Extension.swift
//  Duckmelang
//
//  Created by 주민영 on 3/26/25.
//

import Moya
import Foundation

extension NetworkManager {
    // ✅ 1. 비동기 데이터 요청
    func requestAsync<T: Decodable>(
        target: Endpoint,
        decodingType: T.Type = String.self
    ) async throws -> T {
        let response = try await provider.request(target)
        return try await handleResponseRequired(response, decodingType: decodingType, target: target)
    }

    // ✅ 2. 옵셔널 응답 (데이터가 없을 수도 있음)
    func requestOptionalAsync<T: Decodable>(
        target: Endpoint,
        decodingType: T.Type = String.self
    ) async throws -> T? {
        let response = try await provider.request(target)
        
        // 서버 응답이 비어있는 경우 nil 반환
        if response.data.isEmpty { return nil }
        
        return try await handleResponseOptional(response, decodingType: decodingType, target: target)
    }

    // MARK: - 상태 코드 처리 처리 함수
    // ✅ 공통 응답 처리 함수
    func handleResponseRequired<T: Decodable>(
        _ response: Response,
        decodingType: T.Type,
        target: Endpoint,
        retryCount: Int = 1
    ) async throws -> T {
        guard (200...299).contains(response.statusCode) else {
            return try await handleErrorResponseRequired(response, target: target, decodingType: decodingType)
        }
        
        let decodedResponse = try JSONDecoder().decode(ApiResponse<T>.self, from: response.data)
        guard let result = decodedResponse.result else {
            throw NetworkError.decodingError(devMessage: "[데이터 변환 실패] DTO 양식 확인 필요", userMessage: "데이터 변환에 실패했습니다.\n관리자에게 문의하세요.")
        }
        
        return result
    }
    
    func handleResponseOptional<T: Decodable>(
        _ response: Response,
        decodingType: T.Type,
        target: Endpoint,
        retryCount: Int = 1
    ) async throws -> T? {
        guard (200...299).contains(response.statusCode) else {
            return try await handleErrorResponseOptional(response, target: target, decodingType: decodingType)
        }
        
        let decodedResponse = try JSONDecoder().decode(ApiResponse<T>.self, from: response.data)
        guard let result = decodedResponse.result else {
            throw NetworkError.decodingError(devMessage: "[데이터 변환 실패] DTO 양식 확인 필요", userMessage: "데이터 변환에 실패했습니다.\n관리자에게 문의하세요.")
        }
        
        return result
    }
    
    private func handleErrorResponseRequired<T: Decodable>(
        _ response: Response,
        target: Endpoint,
        decodingType: T.Type,
        retryCount: Int = 1 // ✅ 재시도 횟수 제한 추가
    ) async throws -> T {
        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
        
        let devMessage = errorResponse.message
        
        throw NetworkError.serverError(statusCode: response.statusCode, devMessage: devMessage, userMessage: devMessage)
    }
    
    func handleErrorResponseOptional<T: Decodable>(
        _ response: Response,
        target: Endpoint,
        decodingType: T.Type,
        retryCount: Int = 1 // ✅ 재시도 횟수 제한 추가
    ) async throws -> T? {
        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
        
        let devMessage = errorResponse.message
        
        throw NetworkError.serverError(statusCode: response.statusCode, devMessage: devMessage, userMessage: devMessage)
    }
    
}
