//
//  ReviewViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/31/25.
//

import UIKit

class AfterReviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        self.view = afterReviewView
        
        setupNavigationBar()
        setupAction()
    }
    
    private lazy var afterReviewView: AfterReviewView = {
        let view = AfterReviewView()
        view.cosmosView.didTouchCosmos = { rating in
            let convertedRating = String(format: "%.1f", rating)
            view.cosmosView.text = convertedRating
            print("선택한 별점: \(convertedRating)")
        }
        return view
    }()
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        self.navigationItem.title = "유저네임 님의 페이지"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.aritaSemiBoldFont(ofSize: 18)]
        
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(goHome))
        leftBarButton.tintColor = .grey500
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
    }
    
    private func setupAction() {
        afterReviewView.finishBtn.addTarget(self, action: #selector(clickFinishBtn), for: .touchUpInside)
    }
    
    @objc private func goHome() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func clickFinishBtn() {
        goHome()
        print("리뷰 작성 완료!")
    }
}
