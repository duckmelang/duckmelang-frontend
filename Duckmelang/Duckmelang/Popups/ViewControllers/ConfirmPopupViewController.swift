//
//  ConfirmPopupViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/20/25.
//

import UIKit
import Moya

class ConfirmPopupViewController: UIViewController {
    weak var delegate: ModalDelegate?
    
    var postId: Int?
    var oppositeNickname: String?
    var oppositeProfileImage: String?
    
    protocol ModalDelegate: AnyObject {
        func hideConfirmBtn()
    }
    
    private let provider = MoyaProvider<ChatAPI>(plugins: [TokenPlugin(), NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = confirmPopupView
        
        guard let oppositeProfileImage = self.oppositeProfileImage else { return }
        if let oppositeProfileImageUrl = URL(string: oppositeProfileImage) {
            confirmPopupView.userImage.kf.setImage(with: oppositeProfileImageUrl, placeholder: UIImage())
        }
    }
    
    private lazy var confirmPopupView: CustomPopupView = {
    let view = CustomPopupView(userImage: UIImage(), title: "\(self.oppositeNickname ?? "유저") 님께 동행을 요청할까요?", subTitle: "", leftBtnTitle: "취소", rightBtnTitle: "요청", height: 200)
        
        view.panel.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        view.leftBtn.addTarget(self, action: #selector(leftBtnTap), for: .touchUpInside)
        view.rightBtn.addTarget(self, action: #selector(rightBtnTap), for: .touchUpInside)
        
        return view
    }()
    
    @objc private func closeModal() {
        dismiss(animated: false)
    }
    
    @objc private func leftBtnTap() {
        print("취소")
        closeModal()
    }
    
    @objc private func rightBtnTap() {
        print("동행 요청")
        postRequest()
    }
    
    private func postRequest() {
        guard let postId = self.postId else { return }
        
        provider.request(.postRequest(postId: postId)) { result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    print("✅ 성공")
                } else {
                    let result = try? response.map(ApiResponse<String>.self)
                    let alert = UIAlertController(title: "오류 발생", message: result?.message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                    return
                }
                
                self.delegate?.hideConfirmBtn()
                
                // 두 번째 팝업 생성 및 표시
                if let presentingVC = self.presentingViewController {
                    self.dismiss(animated: false) {
                        let successPopupVC = SuccessPopupViewController()
                        successPopupVC.modalPresentationStyle = .overFullScreen
                        presentingVC.present(successPopupVC, animated: false, completion: nil)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
