//
//  NetworkMonitor.swift
//  Duckmelang
//
//  Created by 김연우 on 2/3/25.
//

import Foundation
import Network
import Moya

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    
    private var isConnected: Bool {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .networkStatusChanged, object: self.isConnected)
            }
        }
    }

    private init() {
        // ✅ 앱 실행 시점에서 네트워크 상태를 즉시 가져오지 않도록 수정
        self.isConnected = false // 초기값을 false로 설정 (연결 안 됨 상태)
        
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let newStatus = (path.status == .satisfied)
            print("📡 네트워크 상태 확인 : \(newStatus ? "연결됨 ✅" : "연결 안 됨 ❌")")
            self.isConnected = newStatus // ✅ 변경된 상태 즉시 반영
        }
        monitor.start(queue: queue)
    }
    
    private var requestTimers: [String: DispatchWorkItem] = [:] // ✅ 요청 추적용 타이머
    


    // ✅ 요청 타임아웃 감지 기능 추가 (기본 10초)
    func startRequestTimeout(target: TargetType, timeout: TimeInterval = 10, failureHandler: @escaping () -> Void) {
        print("⏳ 타임아웃 타이머 시작: \(target) (\(timeout)초 후 실행)")

        let timeoutWorkItem = DispatchWorkItem {
            print("⏳ 요청 타임아웃 발생 - handleRequestFailure 실행: \(target)")
            failureHandler()
        }

        requestTimers[target.path] = timeoutWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout, execute: timeoutWorkItem)
    }
    
    // ✅ 요청 성공 시 타임아웃 타이머 취소
    func cancelRequestTimeout(target: TargetType) {
        if let workItem = requestTimers[target.path] {
            workItem.cancel()
            requestTimers.removeValue(forKey: target.path)
            print("✅ 요청 성공 - 타임아웃 타이머 취소: \(target)")
        }
    }
}

extension Notification.Name {
    static let networkStatusChanged = Notification.Name("networkStatusChanged")
}
