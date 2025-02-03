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
    func showErrorAlert(message: String)
}

final class MoyaLoggerPlugin: PluginType {
    weak var delegate: MoyaErrorHandlerDelegate?

    init(delegate: MoyaErrorHandlerDelegate? = nil) {
        self.delegate = delegate
    }
    
    // ✅ 요청 시작 감지 (`willSend`)
    func willSend(_ request: RequestType, target: TargetType) {
        print("🚀 요청 보냄: \(target) - willSend 실행됨 ✅")

        // ✅ 타임아웃 관리는 NetworkMonitor에서 처리
        NetworkMonitor.shared.startRequestTimeout(target: target) {
            self.handleRequestFailure(target)
        }
    }
    
    // ✅ 응답 수신 (`didReceive`)
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        print("📡 MoyaLoggerPlugin - didReceive 실행됨: \(result)")
        
        // ✅ 응답이 오면 타임아웃 타이머 취소
        NetworkMonitor.shared.cancelRequestTimeout(target: target)

        let transformedResult: Result<Response, MoyaError> = result.flatMap { response in
            let (status, isSuccess, errorMessage) = extractStatusAndMessage(from: response, defaultStatus: response.statusCode)
            
            if (400...599).contains(status) || !isSuccess {
                print("❌ 서버 응답 오류: \(errorMessage)")
                return .failure(MoyaError.statusCode(response))
            }
            
            return .success(response)
        }
        
        switch transformedResult {
        case .success(let response):
            handleSuccess(response, target: target)
        case .failure(let error):
            handleFailure(error, target: target)
        }
    }
    
    // ✅ 서버 응답 없음 (`handleRequestFailure`)
    private func handleRequestFailure(_ target: TargetType) {
        print("⚠️ 요청 실패 감지 (타임아웃 발생) - \(target)")
        DispatchQueue.main.async {
            self.delegate?.showErrorAlert(message: "서버 응답이 없습니다.\n네트워크 상태를 확인하세요.")
        }
    }
    
    // ✅ 성공 응답 처리 (`handleSuccess`)
    private func handleSuccess(_ response: Response, target: TargetType) {
        let statusCode = response.statusCode
        let url = response.request?.url?.absoluteString ?? "nil"
        
        var log = """
        ------------------- 네트워크 통신 성공 -------------------
        [\(statusCode)] \(url)
        ----------------------------------------------------
        API: \(target)
        """
        
        let (status, isSuccess, errorMessage) = extractStatusAndMessage(from: response, defaultStatus: statusCode)
        
        if (400...599).contains(status) || !isSuccess {
            log.append("\n⚠️ 서버 오류: \(errorMessage)")
            print("🔥 DEBUG LOG START (Server Error) 🔥\n\(log)\n🔥 DEBUG LOG END 🔥")
            handleFailure(MoyaError.statusCode(response), target: target)
            return
        }
        
        log.append("\n✅ 서버 응답 성공")
        print("🔥 DEBUG LOG START (Success) 🔥\n\(log)\n🔥 DEBUG LOG END 🔥")
    }
    
    // ✅ JSON 응답 분석 (`extractStatusAndMessage`)
    private func extractStatusAndMessage(from response: Response, defaultStatus: Int) -> (Int, Bool, String) {
        do {
            let jsonResponse = try response.mapJSON() as? [String: Any]
            print("📡 서버 응답 JSON: \(String(describing: jsonResponse))")
            
            let status = jsonResponse?["status"] as? Int ?? defaultStatus
            let isSuccess = jsonResponse?["isSuccess"] as? Bool ?? true
            let errorMessage = jsonResponse?["message"] as? String ??
            jsonResponse?["detail"] as? String ??
            jsonResponse?["title"] as? String ??
            "알 수 없는 서버 오류입니다."
            
            if !isSuccess {
                print("❌ 서버 응답 오류 (isSuccess: false) - \(errorMessage)")
                return (400, false, errorMessage)
            }
            
            return (status, true, errorMessage)
        } catch {
            print("❌ JSON 파싱 오류: \(error.localizedDescription)")
            return (defaultStatus, false, "서버 응답을 처리할 수 없습니다.")
        }
    }
    
    // ✅ 네트워크 오류 처리 (`handleFailure`)
    public func handleFailure(_ error: MoyaError, target: TargetType) {
        print("❌ 네트워크 오류 발생: \(error.localizedDescription)")
        
        var message = "네트워크 오류가 발생했습니다.\n다시 시도해 주세요."
        
        if case let .underlying(underlyingError, _) = error,
           let nsError = underlyingError as NSError? {
            print("🛠 NSError 정보: \(nsError)")
            
            // ✅ `getErrorMessage(for:)` 함수로 통합하여 메시지 가져오기
            message = getErrorMessage(for: nsError.code)
        }
        
        DispatchQueue.main.async {
            self.delegate?.showErrorAlert(message: message)
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
