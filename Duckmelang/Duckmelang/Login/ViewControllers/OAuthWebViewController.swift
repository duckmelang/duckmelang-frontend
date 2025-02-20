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
    
    private lazy var navBar: UINavigationBar = {
        let bar = UINavigationBar()
        let navItem = UINavigationItem(title: authURL?.absoluteString ?? "로그인 중...")
        let closeButton = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(closeWebView))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshWebView))
        navItem.leftBarButtonItem = closeButton
        navItem.rightBarButtonItem = refreshButton
        bar.setItems([navItem], animated: false)
        return bar
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
        setInitialTitle()
        loadAuthURL()
    }
    
    private func setInitialTitle() {
        if let urlString = authURL?.absoluteString {
            navBar.topItem?.title = getLoginService(from: urlString)
        }
    }
    
    private func setupWebView() {
        view.addSubview(navBar)
        view.addSubview(webView)
        webView.navigationDelegate = self
        
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1"
        
        navBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        // SnapKit을 사용한 오토레이아웃 설정
        webView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func loadAuthURL() {
        guard let url = authURL else {
            print("❌ OAuth URL이 없음")
            return
        }
        webView.load(URLRequest(url: url))
    }

    @objc private func closeWebView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func refreshWebView() {
        webView.reload() // 현재 웹 페이지 새로고침
    }
    
    private func getLoginService(from urlString: String) -> String {
        if urlString.contains("kakao") {
            return "Kakao Login"
        } else if urlString.contains("google") {
            return "Google Login"
        } else {
            return "로그인 중..." // 기본값
        }
    }
    
    // OAuth 리디렉트 감지 (JSON 응답 감지)
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let currentURL = webView.url?.absoluteString {
            navBar.topItem?.title = getLoginService(from: currentURL) // ✅ Safari처럼 현재 URL 표시
        }
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
