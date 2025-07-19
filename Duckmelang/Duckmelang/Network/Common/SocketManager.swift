//
//  SocketManager.swift
//  Duckmelang
//
//  Created by 주민영 on 2/13/25.
//

import Foundation

final class SocketManager {
    // WebSocket 통신을 위한 URLSessionWebSocketTask 인스턴스 입니다.
    private var webSocketTask: URLSessionWebSocketTask?
    // URLSession 인스턴스 입니다.
    private let urlSession = URLSession(configuration: .default)
    // 연결 상태 플래그
    private var isConnected = false
    
    // 1. WebSocket 연결을 시작하는 함수
    func connect(to url: URL) {
        var request = URLRequest(url: url)
        
        if let accessToken = KeychainManager.shared.load(key: "accessToken") {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        print("📡 connecting to WebSocket URL: \(url.absoluteString)")
        webSocketTask = urlSession.webSocketTask(with: request)
        webSocketTask?.resume()
        isConnected = true
    }
    
    // 2. 메시지를 수신하는 함수
    func receiveMessage(completion: @escaping (Result<MessageRequest, Error>) -> Void) {
        guard isConnected else {
            print("🛑 연결이 종료되어 더 이상 수신하지 않음")
            return
        }
        
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    do {
                        // JSON 데이터를 MessageRequest로 디코딩
                        let decodedMessage = try JSONDecoder().decode(MessageRequest.self, from: data)
                        print("Decoded Message: \(decodedMessage)")
                        completion(.success(decodedMessage))
                    } catch {
                        print("Failed to decode MessageDTO from data: \(error)")
                        completion(.failure(error))
                    }
                case .string(let string):
                    // 초기 메시지 무시 조건 (예: "WebSocket 연결 완료")
                    if string.starts(with: "WebSocket 연결 완료") {
                        print("Ignored initial message: \(string)")
                        self?.receiveMessage(completion: completion)
                        return
                    }
                    
                    if let jsonData = string.data(using: .utf8) {
                        do {
                            let decodedMessage = try JSONDecoder().decode(MessageRequest.self, from: jsonData)
                            print("Decoded Message from string: \(decodedMessage)")
                            completion(.success(decodedMessage))
                        } catch {
                            print("Failed to decode MessageRequest from string: \(error)")
                            completion(.failure(error))
                        }
                    } else {
                        print("Failed to convert string to Data")
                        completion(.failure(NSError(domain: "StringConversionError", code: -1, userInfo: nil)))
                    }
                    
                default:
                    print("Unsupported message format")
                    completion(.failure(NSError(domain: "UnsupportedMessageType", code: -1, userInfo: nil)))
                }
            case .failure(let error):
                print("WebSocket receive error: \(error)")
                completion(.failure(error))
            }
            
            // 다음 메시지 대기 (연결 유지 중일 때만)
            if let isConnected = self?.isConnected, isConnected {
                self?.receiveMessage(completion: completion)
            }
        }
    }
    
    // 3. 메시지를 송신하는 함수
    func sendMessage(messageRequest: MessageRequest, completion: @escaping (Result<MessageRequest, Error>) -> Void) {
        guard isConnected else {
            completion(.failure(NSError(domain: "WebSocketNotConnected", code: -1)))
            print("🛑 소켓이 연결되지 않아 메시지 전송 불가")
            return
        }
        
        do {
            let jsonData = try JSONEncoder().encode(messageRequest)
            print(jsonData)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                webSocketTask?.send(.string(jsonString)) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(messageRequest))
                    }
                }
            }
        } catch {
            print("Failed to encode message: \(error)")
        }
    }
    
    // 4. WebSocket 연결을 종료하는 힘수
    func disConnect() {
        isConnected = false
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        print("🛑 WebSocket 연결 해제 완료")
    }
}
