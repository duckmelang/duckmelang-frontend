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

    // 🔥 Request 전송 전 로그 출력
    func willSend(_ request: Cancellable, target: TargetType) {
        print("🚀 Request 시작: \(target)")
    }

    // 🔥 Response 수신 후 처리
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            handleSuccess(response, target: target)
        case .failure(let error):
            handleFailure(error, target: target)
        }
    }

    // 🔥 성공 응답 처리
    private func handleSuccess(_ response: Response, target: TargetType) {
        let url = response.request?.url?.absoluteString ?? "nil"
        let statusCode = response.statusCode

        var log = """
        ------------------- 네트워크 통신 성공 -------------------
        [\(statusCode)] \(url)
        ----------------------------------------------------
        API: \(target)
        """

        response.response?.allHeaderFields.forEach {
            log.append("\n\($0): \($1)")
        }

        do {
            if let jsonResponse = try? response.mapJSON() as? [String: Any] {
                if let errorMessage = jsonResponse["title"] as? String,
                   let status = jsonResponse["status"] as? Int, status < 0 {
                    log.append("\n⚠️ 서버 오류 응답: \(errorMessage) (Status: \(status))")
                    print("🔥 DEBUG LOG START (Server Error) 🔥")
                    print(log)
                    print("🔥 DEBUG LOG END 🔥")
                    delegate?.showErrorAlert(message: errorMessage)
                    return
                }
            }

            let loginURL = try response.mapString().trimmingCharacters(in: .whitespacesAndNewlines)
            log.append("\n✅ 서버 응답 받음: \(loginURL)")

            guard !loginURL.isEmpty, let _ = URL(string: loginURL) else {
                log.append("\n⚠️ 유효하지 않은 로그인 URL: \(loginURL)")
                print("🔥 DEBUG LOG START (Invalid URL) 🔥")
                print(log)
                print("🔥 DEBUG LOG END 🔥")
                delegate?.showErrorAlert(message: "유효하지 않은 로그인 URL입니다.")
                return
            }

            log.append("\n🌐 Safari에서 OAuth 로그인 시작")
        } catch {
            log.append("\n❌ JSON 파싱 오류: \(error.localizedDescription)")
            print("🔥 DEBUG LOG START (JSON Parsing Error) 🔥")
            print(log)
            print("🔥 DEBUG LOG END 🔥")
            delegate?.showErrorAlert(message: "서버 응답을 처리할 수 없습니다.")
        }

        print("🔥 DEBUG LOG START (Success) 🔥")
        print(log)
        print("🔥 DEBUG LOG END 🔥")
    }

    // 🔥 실패 응답 처리 (네트워크 오류 포함)
    private func handleFailure(_ error: MoyaError, target: TargetType) {
        let log = """
        ❌ 네트워크 오류 발생
        <-- \(error.errorCode) \(target)
        \(error.failureReason ?? error.errorDescription ?? "unknown error")
        """

        if let response = error.response {
            handleSuccess(response, target: target)
            return
        }

        print("🔥 DEBUG LOG START (Network Failure) 🔥")
        print(log)
        print("🔥 DEBUG LOG END 🔥")

        let message: String
        if let underlyingError = error.errorUserInfo[NSUnderlyingErrorKey] as? NSError {
            message = getErrorMessage(for: underlyingError.code)
        } else {
            message = "네트워크 오류가 발생했습니다.\n다시 시도해 주세요."
        }

        delegate?.showErrorAlert(message: message)
    }

    // 🔥 에러 코드에 따른 메시지 반환
    private func getErrorMessage(for code: Int) -> String {
        switch code {
        case NSURLErrorTimedOut:
            return "서버 응답이 지연되고 있습니다.\n잠시 후 다시 시도해 주세요."
        case NSURLErrorNotConnectedToInternet:
            return "인터넷 연결을 확인하고 다시 시도하세요."
        case NSURLErrorCannotConnectToHost:
            return "서버에 연결할 수 없습니다.\n네트워크 상태를 확인하고 다시 시도해 주세요."
        case 400:
            return "잘못된 요청입니다."
        case 401:
            return "인증이 필요합니다."
        case 403:
            return "접근이 제한되었습니다."
        case 404:
            return "요청한 페이지를 찾을 수 없습니다."
        case 500:
            return "서버 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요."
        default:
            return "네트워크 오류가 발생했습니다.\n다시 시도해 주세요."
        }
    }
}


//MARK: - 사용 방법
//provider.request(endpoint) { _ in
//    // 오류는 MoyaLoggerPlugin에서 처리
//}
//이런식으로 사용하면 됨. 모든 오류는 이 코드에서 처리되므로, 필요한 오류를 추가할것.
