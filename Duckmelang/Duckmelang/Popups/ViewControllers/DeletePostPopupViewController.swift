//
//  deletePostPopupViewController.swift
//  Duckmelang
//
//  Created by nau on 7/17/25.
//
import UIKit

class DeletePostPopupViewController: UIViewController {
    let networkService = MyPageService()
    var postId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = popupView
    }
    
    private lazy var popupView = noImageCustomPopupView(title: "게시글을 삭제하시겠습니까? \n 삭제 시 복구할 수 없습니다.", subTitle: "", leftBtnTitle: "아니요", rightBtnTitle: "네").then {
        $0.leftBtn.addTarget(self, action: #selector(leftBtnTap), for: .touchUpInside)
        $0.rightBtn.addTarget(self, action: #selector(rightBtnTap), for: .touchUpInside)
    }
    
    @objc private func leftBtnTap() {
        print("취소")
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @objc private func rightBtnTap() {
        print("삭제하기")
        deletePost()
        self.presentingViewController?.dismiss(animated: false) {
            NotificationCenter.default.post(name: .postDeleted, object: nil)
        }
    }
    
    private func deletePost() {
        _Concurrency.Task {
            do {
                if let postId = self.postId {
                    try await networkService.deletePost(postId: postId)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension Notification.Name {
    static let postDeleted = Notification.Name("postDeleted")
}
