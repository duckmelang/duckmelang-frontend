//
//  OAuthLoginViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/31/25.
//

import UIKit
import SafariServices

class OAuthLoginViewController: UIViewController {
    
    private var loginURL: URL?

    init(url: URL) {
        self.loginURL = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        openOAuthLogin()
    }
    
    private func openOAuthLogin() {
        guard let url = loginURL else {
            print("❌ OAuth 로그인 URL이 없습니다.")
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .fullScreen
        present(safariVC, animated: true, completion: nil)
    }
}
