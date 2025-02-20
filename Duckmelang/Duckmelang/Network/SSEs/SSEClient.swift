//
//  SSEClient.swift
//  Duckmelang
//
//  Created by 주민영 on 2/20/25.
//

import Foundation

class SSEClient: NSObject, URLSessionDataDelegate {
    private var task: URLSessionDataTask?
    private var session: URLSession!
    private var eventData = ""

    override init() {
        super.init()
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }

    func connectToSSE() {
        guard let url = URL(string: "https://13.125.217.231.nip.io/notifications/subscribe") else { return }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("text/event-stream", forHTTPHeaderField: "Accept")
        request.setValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwiaWF0IjoxNzQwMDMxNTkwLCJleHAiOjE3NDAwMzUxOTB9.Oob_SjjHgYPKr0lL6FLwZ8LhIhTcyEYu_Jwbcg0WilU", forHTTPHeaderField: "Authorization")
        
        print("🔗 SSE 연결 시작")
        
        task = session.dataTask(with: request)
        task?.resume()
    }

    func disconnect() {
        task?.cancel()
        task = nil
    }

    // ✅ 지속적으로 데이터 받기 (SSE 응답 처리)
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard let eventString = String(data: data, encoding: .utf8) else { return }
        print("📩 SSE 데이터 수신: \(eventString)")

        eventData += eventString

        // 🎯 개행 문자 기준으로 이벤트 분리
        let events = eventData.components(separatedBy: "\n")
        for event in events {
            let trimmedEvent = event.trimmingCharacters(in: .whitespacesAndNewlines)

            // 1️⃣ `data:` 이후의 JSON 추출
            if trimmedEvent.hasPrefix("data:") {
                print("✅ 새 알림: \(trimmedEvent)")
                let jsonString = trimmedEvent.replacingOccurrences(of: "data:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                handleReceivedEvent(jsonString)
            }
            // 2️⃣ `id:` 또는 `event:`로 시작하는 경우 무시
            else if trimmedEvent.hasPrefix("id:") || trimmedEvent.hasPrefix("event:") {
                print("⚠️ 알 수 없는 데이터 수신: \(trimmedEvent)")
                continue
            }
            // 3️⃣ 알 수 없는 데이터 로그 출력
            else if !trimmedEvent.isEmpty {
                print("⚠️ 알 수 없는 데이터 수신: \(trimmedEvent)")
            }
        }
    }

    private func handleReceivedEvent(_ event: String) {
        print("📥 SSE 이벤트 파싱: \(event)")

        if let jsonData = event.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            
            if let message = json["content"] as? String {
                print("🔔 New Notification: \(message)")
                DispatchQueue.main.async {
                    NotificationManager.shared.sendLocalNotification(title: "덕메랑", body: message)
                }
            }
        }
    }
}



import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}

    // 🔹 알림 권한 요청
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("알림 권한 요청 실패: \(error.localizedDescription)")
            } else {
                print("알림 권한 상태: \(granted ? "허용됨" : "거부됨")")
            }
        }
    }
    
    // 🔹 로컬 알림 전송
    func sendLocalNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        // ✅ 모든 알림을 클릭하면 NoticeViewController로 이동
        content.userInfo = ["destination": "notice"]

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("🔴 로컬 알림 전송 실패: \(error.localizedDescription)")
            } else {
                print("✅ 로컬 알림 전송 성공")
            }
        }
    }
}

