//
//  OAuthWebViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 2/10/25.
//

import UIKit
import WebKit
import SnapKit
import Then
import Moya

class OAuthWebViewController: UIViewController, WKNavigationDelegate, MoyaErrorHandlerDelegate {
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "오류 발생",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    
    lazy var provider: MoyaProvider<LoginAPI> = {
        return MoyaProvider<LoginAPI>(plugins: [TokenPlugin(),MoyaLoggerPlugin()])
    }()
    
    // `WKWebView`를 Then을 사용하여 선언
    private let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration()).then {
        $0.navigationDelegate = nil  // 초기에는 nil, 이후 `self` 설정
    }
    
    var authURL: URL?
    var oauthCompletion: ((Int, Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadAuthURL()
    }
    
    private func setupWebView() {
        view.addSubview(webView)
        webView.navigationDelegate = self
        
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1"
        
        // SnapKit을 사용한 오토레이아웃 설정
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func loadAuthURL() {
        guard let url = authURL else {
            print("❌ OAuth URL이 없음")
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    // OAuth 리디렉트 감지 (JSON 응답 감지)
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.innerText") { [weak self] (result, error) in
            guard let jsonString = result as? String, error == nil else {
                print("❌ JSON 데이터 감지 실패")
                return
            }
            print("🔗 감지된 JSON 응답: \(jsonString)")
            
            // OAuth 인증 완료 후 모달 닫기 + 정보 처리
            self?.processOAuthResponse(jsonString)
        }
    }
    
    // JSON 응답에서 memberId 추출 후 처리
    private func processOAuthResponse(_ jsonString: String) {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("❌ JSON 문자열을 데이터로 변환할 수 없음")
            return
        }

        do {
            let response = try JSONDecoder().decode(SocialLoginResponse.self, from: jsonData)
            
            if response.isSuccess {
                let memberId = response.result.memberId
                let profileComplete = response.result.profileComplete
                let accessToken = response.result.accessToken
                let refreshToken = response.result.refreshToken
                
                // ✅ 🔥 Access Token & Refresh Token 저장
                KeychainManager.shared.save(key: "accessToken", value: accessToken)
                KeychainManager.shared.save(key: "refreshToken", value: refreshToken)
                
                print("🔑 Access Token 저장 완료: \(accessToken.prefix(10))...")
                print("🔑 Refresh Token 저장 완료: \(refreshToken.prefix(10))...")
                
                // 전달된 데이터로 OnboardingViewController로 이동할 수 있게 콜백 호출
                self.oauthCompletion?(memberId, profileComplete)
                
                // 모달을 닫기
                self.dismiss(animated: true, completion: nil)
            } else {
                print("❌ OAuth 로그인 실패: \(response.message)")
            }
        } catch {
            print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
        }
    }
}
