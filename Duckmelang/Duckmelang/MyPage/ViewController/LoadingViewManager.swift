//
//  LoadingViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 2/24/25.
//

import UIKit

class LoadingViewManager {
    
    static let shared = LoadingViewManager()
    
    private var loadingView: UIView?
    
    private init() {} // ✅ 싱글톤 - 외부에서 인스턴스 생성 방지
    private var activityIndicator: UIActivityIndicatorView?
    
    // ✅ 로딩 화면 표시
    func show() {
        
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return
        } // ✅ 올바른 윈도우 접근
        
        hide()
        
        let loadingView = UIView(frame: window.bounds)
        loadingView.backgroundColor = .white// 반투명 배경
        loadingView.isUserInteractionEnabled = false
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        
        loadingView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
        }
        
        window.addSubview(loadingView) // ✅ UIWindow 위에 추가
        self.loadingView = loadingView
        self.activityIndicator = activityIndicator
    }

    // ✅ 로딩 화면 제거
    func hide() {
        DispatchQueue.main.async {
            print("hideLoading() 실행됨")
            self.activityIndicator?.stopAnimating()
            self.activityIndicator?.removeFromSuperview()
            self.loadingView?.removeFromSuperview()
            self.loadingView = nil
            self.activityIndicator = nil
        }
    }
}
