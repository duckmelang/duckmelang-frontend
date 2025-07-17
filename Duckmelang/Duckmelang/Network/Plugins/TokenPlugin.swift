//
//  TokenPlugin.swift
//  Duckmelang
//
//  Created by 김연우 on 2/20/25.
//

import Moya
import Foundation
import UIKit

final class TokenPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        
        if target.path.contains("/login") || target.path.contains("/token/refresh") {
            return request
        }
        
        // ✅ Access Token 가져오기
        if let accessToken = KeychainManager.shared.load(key: "accessToken") {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            if response.statusCode == 401 {
                print("🔄 Access Token 만료! Refresh Token을 사용하여 갱신 시도")
                refreshAccessToken { isSuccess in
                    if isSuccess {
                        print("✅ Access Token 갱신 완료. 원래 요청 다시 시도")
                        self.retryRequest(target: target) // ✅ 원래 요청 재시도
                    } else {
                        print("❌ Refresh Token도 만료됨. 로그아웃 처리")
                        self.logout() // ✅ Refresh Token도 만료되면 로그아웃
                    }
                }
            }
        case .failure(let error):
            print("❌ API 요청 실패: \(error.localizedDescription)")
        }
    }
    
    private func refreshAccessToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = KeychainManager.shared.load(key: "refreshToken") else {
            print("❌ Refresh Token 없음. 로그아웃 진행")
            completion(false)
            return
        }

        let networkService = LoginService()

        let refreshRequest = RefreshTokenRequest(refreshToken: refreshToken)
        
        _Concurrency.Task {
            do {
                let result = try await networkService.postRefreshToken(refreshToken: refreshRequest)
                
                let newAccessToken = result.accessToken
                let newRefreshToken = result.refreshToken
                
                KeychainManager.shared.save(key: "accessToken", value: newAccessToken)
                KeychainManager.shared.save(key: "refreshToken", value: newRefreshToken)
                
                completion(true)
            }
            catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    private func retryRequest(target: TargetType) {
        let provider = MoyaProvider<MultiTarget>() // API 재요청용 Provider
        
        provider.request(MultiTarget(target)) { result in
            switch result {
            case .success(let response):
                print("✅ 원래 요청 재시도 성공: \(response.statusCode)")
            case .failure(let error):
                print("❌ 원래 요청 재시도 실패: \(error.localizedDescription)")
            }
        }
    }
    
    public func logout() {
        DispatchQueue.main.async {
            // ✅ Keychain에서 저장된 토큰 삭제
            KeychainManager.shared.delete(key: "accessToken")
            KeychainManager.shared.delete(key: "refreshToken")

           // ✅ UIWindowScene 가져오기
           guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                 let window = scene.windows.first else {
               print("❌ 윈도우 찾기 실패")
              return
           }

           // ✅ OnBoardingViewController를 새로운 루트 뷰 컨트롤러로 설정
           let onboardingVC = OnBoardingViewController()
           let navController = UINavigationController(rootViewController: onboardingVC) // ✅ 네비게이션 포함

        window.rootViewController = navController
        window.makeKeyAndVisible()
        }
        print("🔐 로그아웃되었습니다")
    }
}
