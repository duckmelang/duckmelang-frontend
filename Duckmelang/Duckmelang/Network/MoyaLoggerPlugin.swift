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

        let transformedResult: Result<Response, MoyaError> = result.flatMap { response in
            if (400...599).contains(response.statusCode) {
                return .failure(MoyaError.statusCode(response))  // ✅ 실패로 변환
            } else {
                return .success(response)
            }
        }

        switch transformedResult {
        case .success(let response):
            handleSuccess(response, target: target)
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

        let (status, errorMessage) = extractStatusAndMessage(from: response, defaultStatus: statusCode)

        if (400...599).contains(status) {  // ✅ 모든 400~599 오류 처리
            log.append("\n⚠️ 서버 오류: \(errorMessage)")

            print("🔥 DEBUG LOG START (Server Error) 🔥")
            print(log)
            print("🔥 DEBUG LOG END 🔥")

            // 🔥 400~599 오류일 경우 handleFailure() 호출하고 return!
            handleFailure(MoyaError.statusCode(response), target: target)
            return  // 🚨 여기가 중요! return이 없으면 아래 코드 실행됨!
        }

        // ✅ 정상 응답 처리
        log.append("\n✅ 서버 응답 성공")

        print("🔥 DEBUG LOG START (Success) 🔥")
        print(log)
        print("🔥 DEBUG LOG END 🔥")
    }
    

    // ✅ JSON에서 status와 오류 메시지를 추출하는 함수 (별도 분리)
    private func extractStatusAndMessage(from response: Response, defaultStatus: Int) -> (Int, String) {
        do {
            let jsonResponse = try response.mapJSON() as? [String: Any]
            print("📡 서버 응답 JSON: \(String(describing: jsonResponse))")

            let status = jsonResponse?["status"] as? Int ?? defaultStatus
            let errorMessage = jsonResponse?["detail"] as? String ??
                               jsonResponse?["title"] as? String ??
                               "알 수 없는 서버 오류입니다."

            return (status, errorMessage)

        } catch {
            print("❌ JSON 파싱 오류: \(error.localizedDescription)")
            return (defaultStatus, "서버 응답을 처리할 수 없습니다.")
        }
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
