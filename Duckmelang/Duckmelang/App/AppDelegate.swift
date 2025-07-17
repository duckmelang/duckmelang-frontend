//
//  AppDelegate.swift
//  Duckmelang
//
//  Created by 주민영 on 1/9/25.
//

import UIKit
import KakaoSDKCommon
import FirebaseCore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var sseClient = SSEClient()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        //MARK: - 파이어베이스 설정
        FirebaseApp.configure()
        Auth.auth().languageCode = "kr"
        
        UNUserNotificationCenter.current().delegate = self
        NotificationManager.shared.requestNotificationPermission()
        
        sseClient.connectToSSE()
        
        //MARK: - 카카오로그인 설정
        KakaoSDK.initSDK(appKey: "\(Config.nativeAppKey)")
        
        return true
    }
    
    // MARK: - 포그라운드에서도 알림 표시하도록 설정
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .list])
    }
    
    // MARK: - 사용자가 알림을 클릭했을 때 실행되는 메서드
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let destination = userInfo["destination"] as? String, destination == "notice" {
            navigateToNoticeViewController()
        }
        
        completionHandler()
    }
    
    // MARK: - NoticeViewController로 이동하는 함수
    private func navigateToNoticeViewController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            print("🔴 UIWindow를 찾을 수 없음")
            return
        }
        
        // ✅ UINavigationController가 있는 경우, 기존 네비게이션을 활용
        if let navigationController = window.rootViewController as? UINavigationController {
            let notificationVC = NoticeViewController()
            print("✅ NoticeViewController로 이동!")
            navigationController.pushViewController(notificationVC, animated: true)
        } else {
            // ✅ UINavigationController가 없으면, 새로운 뷰컨을 루트로 설정
            let notificationVC = NoticeViewController()
            let navigationController = UINavigationController(rootViewController: notificationVC)
            navigationController.setNavigationBarHidden(true, animated: false)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            print("✅ 새로운 UINavigationController 생성 및 NoticeViewController 표시")
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

