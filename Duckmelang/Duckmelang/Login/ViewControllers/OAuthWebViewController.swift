//
//  OAuthWebViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 2/10/25.
//

import UIKit
import WebKit

class OAuthWebViewController: UIViewController, WKNavigationDelegate {
    let networkService = LoginService()
    
    var authURL: URL?
    var oauthCompletion: ((Int, Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setInitialTitle()
        loadAuthURL()
    }
    
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
            
            if currentURL.contains("code=") {
                Task {
                    await handleKakaoLoginResult()
                }
            }
        }
    }
    
    private func handleKakaoLoginResult() async {
        do {
            startLoading()
            
            let result = try await networkService.kakaoLogin()
            
            let memberId = result.memberId
            let profileComplete = result.profileComplete
            
            KeychainManager.shared.save(key: "accessToken", value: result.accessToken)
            KeychainManager.shared.save(key: "refreshToken", value: result.refreshToken)

            DispatchQueue.main.async {
                self.oauthCompletion?(memberId, profileComplete)
                self.dismiss(animated: true, completion: nil)
            }
            
            stopLoading()
        } catch {
            stopLoading()
            print("❌ 카카오 로그인 실패: \(error.localizedDescription)")
        }
    }
}
