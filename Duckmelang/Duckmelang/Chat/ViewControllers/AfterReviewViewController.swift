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
    
    var oppositeId: Int?
    var postId: Int?
    private var applicationId: Int?
    
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
            view.ratingLabel.text = self.getRatingMessage(Double(convertedRating) ?? 0.0)
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
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func clickFinishBtn() {
        print("리뷰 작성 완료!")
        postReview()
    }
    
    private func getReviewInformation() {
        print("리뷰 정보 불러오기")
        provider.request(.getReviewsInformation(memberId: oppositeId!, postId: postId!)) { result in
            switch result {
            case .success(let response):
                let response = try? response.map(ApiResponse<ReviewInformation>.self)
                guard let info = response?.result else { return }
                print("리뷰 정보: \(info)")
                
                self.applicationId = info.applicationId
                DispatchQueue.main.async {
                    // 후기글 작성 페이지 내 관련 정보 업데이트
                    self.afterReviewView.detailMain.updateView(info: info)
                    // 네비바 타이틀 업데이트
                    self.navigationItem.title = "\(info.name) 님의 페이지"
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func postReview() {
        if applicationId == nil {
            print("리뷰를 불러오지 않았습니다.")
            return
        }
        
        let review = ReviewRequest(
            score: afterReviewView.cosmosView.rating,
            content: afterReviewView.reviewTextView.text,
            receiverId: oppositeId!,
            applicationId: applicationId!
        )
        
        provider.request(.postReviews(reviewData: review)) { result in
            switch result {
            case .success(let response):
                print(response)
                self.goHome()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getRatingMessage(_ rating: Double) -> String {
        switch rating {
        case 4.0...5.0:
            return "훌륭해요! 기대 이상이에요!"
        case 3.0..<4.0:
            return "괜찮아요! 무난한 선택이에요."
        case 2.0..<3.0:
            return "보통이에요. 개선되면 좋겠어요."
        case 1.0..<2.0:
            return "아쉬운 점이 많아요. 기대에 못 미쳤어요."
        default:
            return "실망스러워요. 추천하기 어려워요."
        }
    }

}
