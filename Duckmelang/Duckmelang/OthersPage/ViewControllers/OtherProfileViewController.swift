//
//  OtherProfileViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class OtherProfileViewController: UIViewController {
    let networkService = OtherPageService()
    
    private var currentViewController: UIViewController?
    
    var oppositeId: Int?
    var profileData: OtherProfileData?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = otherProfileView
        
        navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        navigationController?.isNavigationBarHidden = true
        
        setupAction()
        getProfileInfo()
        segmentedControlValueChanged(
            segment: otherProfileView.otherProfileBottomView.segmentedControl
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view = otherProfileView
        
        navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        setupAction()
        getProfileInfo()
        segmentedControlValueChanged(
            segment: otherProfileView.otherProfileBottomView.segmentedControl
        )
    }

    private lazy var otherProfileView = OtherProfileView()
    
    private func setupAction() {
        otherProfileView.otherProfileTopView.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        // segmentedControl
        otherProfileView.otherProfileBottomView.segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(segment:)), for: .valueChanged)
        
        // 유저 이미지 누르면 이미지 화면으로 이동되게
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userImageTapped))
        otherProfileView.otherProfileTopView.profileImage.isUserInteractionEnabled = true
        otherProfileView.otherProfileTopView.profileImage.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func backBtnDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func segmentedControlValueChanged(segment: UISegmentedControl) {
        let selectedIndex = segment.selectedSegmentIndex
        let newViewController: UIViewController
        
        switch selectedIndex {
        case 0:
            let postsVC = OtherPostsViewController()
            postsVC.oppositeId = self.oppositeId
            newViewController = postsVC
        case 1:
            let otherReviewsVC = OtherReviewsViewController()
            otherReviewsVC.oppositeId = self.oppositeId
            newViewController = otherReviewsVC
        default:
            return
        }
        
        moveUnderline()
        switchToViewController(newViewController)
    }
    
    private func moveUnderline() {
        // 세그먼트 컨트롤 하단바 이동
        let width = otherProfileView.otherProfileBottomView.segmentedControl.frame.width / CGFloat(otherProfileView.otherProfileBottomView.segmentedControl.numberOfSegments)
        let xPosition = otherProfileView.otherProfileBottomView.segmentedControl.frame.origin.x + (width * CGFloat(otherProfileView.otherProfileBottomView.segmentedControl.selectedSegmentIndex))
        
        UIView.animate(withDuration: 0.2) {
            self.otherProfileView.otherProfileBottomView.underLineView.frame.origin.x = xPosition
        }
    }
    
    private func switchToViewController(_ newViewController: UIViewController) {
        if let currentVC = currentViewController {
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }
        
        addChild(newViewController)
        newViewController.view.frame = otherProfileView.bounds
        otherProfileView.addSubview(newViewController.view)
        newViewController.didMove(toParent: self)
        
        newViewController.view.snp.makeConstraints {
            $0.top.equalTo(otherProfileView.otherProfileBottomView.underLineView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        currentViewController = newViewController
    }
    
    @objc private func userImageTapped() {
        let otherImageVC = OtherImageViewController()
        otherImageVC.oppositeId = self.oppositeId
        otherImageVC.profileData = self.profileData
        navigationController?.pushViewController(otherImageVC, animated: true)
    }
    
    private func getProfileInfo() {
        Task {
            do {
                startLoading()
                guard let oppositeId = self.oppositeId else { return }
                
                let result = try await networkService.getOtherProfile(memberId: oppositeId)
                self.profileData = result
                
                // OtherPageTopView에 데이터 반영
                DispatchQueue.main.async {
                    self.otherProfileView.otherProfileTopView.profileData = result
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
