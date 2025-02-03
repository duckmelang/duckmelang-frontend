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

    func willSend(_ request: RequestType, target: TargetType) {
        print("🚀 Request 시작: \(target)")
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        print("📡 MoyaLoggerPlugin - didReceive 실행됨: \(result)")

        switch result {
        case .success(let response):
            if response.statusCode >= 400 {  // ✅ 500 서버 오류 감지
                handleFailure(MoyaError.statusCode(response), target: target)
                return
            } else {
                handleSuccess(response, target: target) }
        case .failure(let error):
            handleFailure(error, target: target)
        }
    }

    private func handleSuccess(_ response: Response, target: TargetType) {
        let statusCode = response.statusCode
        let url = response.request?.url?.absoluteString ?? "nil"

        var log = """
        ------------------- 네트워크 통신 성공 -------------------
        [\(statusCode)] \(url)
        ----------------------------------------------------
        API: \(target)
        """

        do {
            let jsonResponse = try response.mapJSON() as? [String: Any]
            print("📡 서버 응답 JSON: \(String(describing: jsonResponse))")

            // 🔥 `isSuccess` 값이 false면 실패로 처리
            if let isSuccess = jsonResponse?["isSuccess"] as? Bool, !isSuccess {
                let errorMessage = jsonResponse?["message"] as? String ?? "서버 오류가 발생했습니다."
                log.append("\n⚠️ 서버 응답 오류: \(errorMessage)")

                print("🔥 DEBUG LOG START (Server Error) 🔥")
                print(log)
                print("🔥 DEBUG LOG END 🔥")

                DispatchQueue.main.async {
                    self.delegate?.showErrorAlert(message: errorMessage)
                }
                return
            }

            // ✅ 200 응답이면서 `isSuccess: true`인 경우 정상 처리
            log.append("\n✅ 서버 응답 성공")

        } catch {
            log.append("\n❌ JSON 파싱 오류: \(error.localizedDescription)")
            print("🔥 DEBUG LOG START (JSON Parsing Error) 🔥")
            print(log)
            print("🔥 DEBUG LOG END 🔥")

            DispatchQueue.main.async {
                self.delegate?.showErrorAlert(message: "서버 응답을 처리할 수 없습니다.")
            }
        }

        print("🔥 DEBUG LOG START (Success) 🔥")
        print(log)
        print("🔥 DEBUG LOG END 🔥")
    }

    private func handleFailure(_ error: MoyaError, target: TargetType) {
            print("❌ 네트워크 오류 발생: \(error.localizedDescription)")

            var message = "네트워크 오류가 발생했습니다.\n다시 시도해 주세요."

            // ✅ Alamofire AFError 내부에서 NSError 추출
            if case let .underlying(underlyingError, _) = error,
               let nsError = underlyingError as NSError? {
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
            return "서버 오류가 발생했습니다.\n관리자에게 문의 바랍니다."
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
