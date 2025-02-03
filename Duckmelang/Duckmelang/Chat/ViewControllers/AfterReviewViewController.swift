//
//  ReviewViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/31/25.
//

import UIKit
import Moya

class AfterReviewViewController: UIViewController {
    private let provider = MoyaProvider<ReviewAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    private var applicationId: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        self.view = afterReviewView
        
        setupNavigationBar()
        setupAction()
        getReviewInformation()
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
        print("리뷰 작성 완료!")
        postReview()
    }
    
    private func getReviewInformation() {
        print("리뷰 정보 불러오기")
        provider.request(.getReviewsInformation(memberId: 11, myId: 1)) { result in
            switch result {
            case .success(let response):
                // TODO: 백엔드 수정 후 API 수정해야함
                let response = try? response.map(ApiResponse<[ReviewInformation]>.self)
                if let info = response?.result?.first {
                    print("리뷰 정보: \(info)")
                    self.applicationId = info.applicationId
                    DispatchQueue.main.async {
                        // 후기글 작성 페이지 내 관련 정보 업데이트
                        self.afterReviewView.detailMain.updateView(info: info)
                        // 네비바 타이틀 업데이트
                        self.navigationItem.title = "\(info.name) 님의 페이지"
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func postReview() {
        print("후기글 작성")
//        applicationId = 0
        
        if applicationId == nil {
            print("리뷰를 불러오지 않았습니다.")
            return
        }
        
        let review = ReviewRequest(
            score: afterReviewView.cosmosView.rating,
            content: afterReviewView.reviewTextView.text,
            receiverId: 11, // 임시 데이터
            applicationId: applicationId ?? 0 // 임시 데이터
        )
        
        provider.request(.postReviews(memberId: 1, reviewData: review)) { result in
            switch result {
            case .success(let response):
                print(response)
                self.goHome()
            case .failure(let error):
                print(error)
            }
        }
    }
}
