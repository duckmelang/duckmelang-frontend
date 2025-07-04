//
//  UIViewController+Extensions.swift
//  Duckmelang
//
//  Created by 주민영 on 3/26/25.
//

import UIKit
import SnapKit

extension UIViewController {
    private struct LoadingIndicator {
        static var activityIndicator: UIActivityIndicatorView?
    }
    
    /// viewWillAppear에서 호출(로딩인디케이터 기본 세팅)
    func setupLoadingIndicator() {
        guard LoadingIndicator.activityIndicator == nil else { return } // 중복 추가 방지
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .grey600
        indicator.hidesWhenStopped = true
        
        view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        LoadingIndicator.activityIndicator = indicator
    }
    
    /// API 호출 코드 실행 전 호출
    func startLoading() {
        DispatchQueue.main.async {
            self.setupLoadingIndicator()
            LoadingIndicator.activityIndicator?.startAnimating()
        }
    }
    
    /// API 호출 후(성공/실패 분기 모두에서) UI 업데이트 진행 전 호출
    func stopLoading() {
        DispatchQueue.main.async {
            LoadingIndicator.activityIndicator?.stopAnimating()
            LoadingIndicator.activityIndicator?.removeFromSuperview()
            LoadingIndicator.activityIndicator = nil
        }
    }
}

extension UIViewController {
    
    func screen() -> UIScreen? {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            // 99.9% 확률로 실패할 일은 없을 것 같은데, 만약 실패 한다면 view로 접근하여 사용하기 (1번 방법)
            return view.window?.windowScene?.screen
        }
        
        // 2번 방법
        return window.screen
    }
}

extension UIScreen {
    static var current: UIScreen? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.screen
        }
        return nil
    }

    static var width: CGFloat {
        (current?.bounds.width)!
    }

    static var height: CGFloat {
        (current?.bounds.height)!
    }

    static var size: CGSize {
        (current?.bounds.size)!
    }
}
