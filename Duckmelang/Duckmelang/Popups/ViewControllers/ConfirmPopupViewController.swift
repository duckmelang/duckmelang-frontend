//
//  ConfirmPopupViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/20/25.
//

import UIKit

class ConfirmPopupViewController: UIViewController {
    weak var delegate: ModalDelegate?
    
    var postId: Int?
    var oppositeNickname: String?
    var oppositeProfileImage: String?
    
    protocol ModalDelegate: AnyObject {
        func hideConfirmBtn()
    }
    
    private let networkService = ChatService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = confirmPopupView
        
        guard let oppositeProfileImage = self.oppositeProfileImage else { return }
        if let oppositeProfileImageUrl = URL(string: oppositeProfileImage) {
            confirmPopupView.userImage.kf.setImage(with: oppositeProfileImageUrl, placeholder: UIImage())
        }
    }
    
    private lazy var confirmPopupView: CustomPopupView = {
    let view = CustomPopupView(userImage: UIImage(), title: "\(self.oppositeNickname ?? "유저") 님께 동행을 요청할까요?", subTitle: "", leftBtnTitle: "취소", rightBtnTitle: "요청")
        
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
        Task {
            do {
                guard let postId = self.postId else { return }
                startLoading()
                
                _ = try await networkService.postRequest(postId: postId)
                
                self.delegate?.hideConfirmBtn()
                
                // 두 번째 팝업 생성 및 표시
                if let presentingVC = self.presentingViewController {
                    self.dismiss(animated: false) {
                        let successPopupVC = SuccessPopupViewController()
                        successPopupVC.modalPresentationStyle = .overFullScreen
                        presentingVC.present(successPopupVC, animated: false, completion: nil)
                    }
                }
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
}
