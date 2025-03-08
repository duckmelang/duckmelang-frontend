//
//  MoyaLoggerPlugin.swift
//  Duckmelang
//
//  Created by 김연우 on 2/3/25.
//

import Foundation
import Moya
import UIKit

protocol MoyaErrorHandlerDelegate: AnyObject {
    func showAlert(title: String, message: String)
}

final class MoyaLoggerPlugin: PluginType {
    weak var delegate: MoyaErrorHandlerDelegate?

    init(delegate: MoyaErrorHandlerDelegate? = nil) {
        self.delegate = delegate
    }
    
    func willSend(_ request: RequestType, target: TargetType) {
        print("🚀 요청 보냄: \(target)")
    }
    
    func didReceive(_ result: Swift.Result<Response, MoyaError>, target: TargetType) {
        let url = target.baseURL.appendingPathComponent(target.path).absoluteString
        print("📡 MoyaLoggerPlugin : \(result)")
        print("🔗 API URL: \(url)")  // API 주소 출력

        switch result {
        case .success(let response):
            handleSuccess(response, target: target)
        case .failure(let error):
            handleFailure(error, target: target)
        }
    }
    
    private func handleRequestFailure(_ target: TargetType) {
        print("⚠️ 요청 실패 감지 (타임아웃 발생) - \(target)")
        DispatchQueue.main.async {
            self.delegate?.showAlert(title: "오류", message: "서버 응답이 없습니다.\n네트워크 상태를 확인하세요.")
        }
    }
    
    private func handleSuccess(_ response: Response, target: TargetType) {
        let url = target.baseURL.appendingPathComponent(target.path).absoluteString
        print("✅ 응답 성공: \(response.statusCode) - \(target)")
        print("📍 성공한 API URL: \(url)")
        
        guard (200...299).contains(response.statusCode) else {
            print("⚠️ 예상치 못한 상태 코드: \(response.statusCode)")
            return
        }
        
        // 필요 시 추가 처리 가능
    }
    
    public func handleFailure(_ error: MoyaError, target: TargetType) {
        let url = target.baseURL.appendingPathComponent(target.path).absoluteString
        print("❌ 네트워크 오류 발생: \(error.localizedDescription)")
        print("📍 실패한 API URL: \(url)")
        
        var message = "네트워크 오류가 발생했습니다.\n다시 시도해 주세요."
        
        if case let .underlying(underlyingError, _) = error,
           let nsError = underlyingError as NSError? {
            message = getErrorMessage(for: nsError.code)
        }

        DispatchQueue.main.async {
            self.delegate?.showAlert(title: "오류", message: message)
        }
    }
    
    private func getErrorMessage(for code: Int) -> String {
        switch code {
        case NSURLErrorTimedOut:
            return "서버 응답이 지연되고 있습니다.\n잠시 후 다시 시도해 주세요."
        case NSURLErrorNotConnectedToInternet:
            return "인터넷 연결이 끊어졌습니다.\n네트워크 상태를 확인하세요."
        case NSURLErrorCannotConnectToHost:
            return "서버에 연결할 수 없습니다.\n서버 상태를 확인하세요."
        case NSURLErrorNetworkConnectionLost:
            return "네트워크 연결이 일시적으로 끊어졌습니다.\n다시 시도해주세요."
        case NSURLErrorDNSLookupFailed:
            return "서버 주소를 찾을 수 없습니다.\nURL을 확인하세요."
        case 400:
            return "잘못된 요청입니다."
        case 401:
            return "인증이 필요합니다."
        case 403:
            return "접근이 제한되었습니다."
        case 404:
            return "요청한 페이지를 찾을 수 없습니다."
        case 500:
            return "서버 오류가 발생했습니다.\n관리자에게 문의 바랍니다."
        default:
            return "네트워크 오류가 발생했습니다.\n다시 시도해 주세요."
        }
    }
}
