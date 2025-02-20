//
//  OtherProfileModifyViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Moya

class OtherProfileViewController: UIViewController {
    private let provider = MoyaProvider<OtherPageAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    var selectedTag: Int = 0
    
    var oppositeId: Int?
    var profileData: OtherProfileData?
    var otherPostsData: [PostDTO] = []
    var otherReviewsData: [OtherReviewDTO] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = otherProfileView
        
        navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        otherProfileView.otherProfileBottomView.cosmosView.isHidden = true
        otherProfileView.otherProfileBottomView.cosmosStack.isHidden = true
        
        setupAction()
        setupDelegate()
        getProfileInfo()
        getOtherPosts()
        getOtherReviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view = otherProfileView
        
        navigationController?.isNavigationBarHidden = true
        otherProfileView.otherProfileBottomView.cosmosView.isHidden = true
        otherProfileView.otherProfileBottomView.cosmosStack.isHidden = true
        
        setupAction()
        setupDelegate()
        getProfileInfo()
        getOtherPosts()
        getOtherReviews()
    }

    private lazy var otherProfileView = OtherProfileView()
    
    @objc
    private func backBtnDidTap() {
        self.navigationController?.popViewController(animated: true)
    }

    private func setupDelegate() {
        otherProfileView.otherProfileBottomView.uploadPostView.dataSource = self
        otherProfileView.otherProfileBottomView.uploadPostView.delegate = self
        
        otherProfileView.otherProfileBottomView.reviewTableView.dataSource = self
        otherProfileView.otherProfileBottomView.reviewTableView.delegate = self
    }
    
    private func setupAction() {
        otherProfileView.otherProfileTopView.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        // segmentedControl
        otherProfileView.otherProfileBottomView.segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(segment:)), for: .valueChanged)
        
        // 유저 이미지 누르면 이미지 화면으로 이동되게
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userImageTapped))
        otherProfileView.otherProfileTopView.profileImage.isUserInteractionEnabled = true
        otherProfileView.otherProfileTopView.profileImage.addGestureRecognizer(tapGesture)
    }
    
    @objc private func segmentedControlValueChanged(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            otherProfileView.otherProfileBottomView.uploadPostView.isHidden = false
            otherProfileView.otherProfileBottomView.reviewTableView.isHidden = true
            otherProfileView.otherProfileBottomView.cosmosView.isHidden = true
            otherProfileView.otherProfileBottomView.cosmosStack.isHidden = true
        } else {
            otherProfileView.otherProfileBottomView.uploadPostView.isHidden = true
            otherProfileView.otherProfileBottomView.reviewTableView.isHidden = false
            otherProfileView.otherProfileBottomView.cosmosView.isHidden = false
            otherProfileView.otherProfileBottomView.cosmosStack.isHidden = false
        }
        
        let width = otherProfileView.otherProfileBottomView.segmentedControl.frame.width / CGFloat(otherProfileView.otherProfileBottomView.segmentedControl.numberOfSegments)
        let xPosition = otherProfileView.otherProfileBottomView.segmentedControl.frame.origin.x + (width * CGFloat(otherProfileView.otherProfileBottomView.segmentedControl.selectedSegmentIndex))
        
        UIView.animate(withDuration: 0.2) {
            self.otherProfileView.otherProfileBottomView.underLineView.frame.origin.x = xPosition
        }
    }
    
    @objc private func userImageTapped() {
        let otherImageVC = OtherImageViewController()
        otherImageVC.oppositeId = self.oppositeId
        otherImageVC.profileData = self.profileData
        navigationController?.pushViewController(otherImageVC, animated: true)
    }
    
    private func getProfileInfo() {
        provider.request(.getOtherProfile(memberId: self.oppositeId!)) { result in
            switch result {
            case .success(let response):
                let response = try? response.map(ApiResponse<OtherProfileData>.self)
                guard let profile = response?.result else { return }
                self.profileData = profile
                print("다른 사람 정보 : \(profile)")
                
                // OtherPageTopView에 데이터 반영
                DispatchQueue.main.async {
                    self.updateUI(profile)
                }
            case .failure(let error):
                print("프로필 불러오기 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateUI(_ profileData: OtherProfileData) {
        self.otherProfileView.otherProfileTopView.profileData = profileData
    }
    
    // 게시글 가져오기
    private func getOtherPosts() {
        provider.request(.getOtherPosts(memberId: self.oppositeId!, page: 0)) { result in
            switch result {
            case .success(let response):
                self.otherPostsData.removeAll()
                let response = try? response.map(ApiResponse<PostResponse>.self)
                guard let result = response?.result?.postList else { return }
                self.otherPostsData = result
                
                print("다른 사람 게시글: \(self.otherPostsData)")
                DispatchQueue.main.async {
                    self.otherProfileView.otherProfileBottomView.uploadPostView.reloadData()
                }
            case .failure(let error):
                print("게시글 불러오기 실패: \(error.localizedDescription)")
            }
        }
    }
    
    // 후기 가져오기
    private func getOtherReviews() {
        provider.request(.getOtherReviews(memberId: self.oppositeId!)) { result in
            switch result {
            case .success(let response):
                self.otherReviewsData.removeAll()
                let response = try? response.map(ApiResponse<OtherReviewResponse>.self)
                guard let result = response?.result else { return }
                self.otherReviewsData = result.reviewList
                
                print("다른 사람 후기: \(self.otherReviewsData)")
                DispatchQueue.main.async {
                    self.otherProfileView.otherProfileBottomView.cosmosView.rating = result.average
                    self.otherProfileView.otherProfileBottomView.cosmosCount.text = "\(result.average)"
                    self.otherProfileView.otherProfileBottomView.reviewTableView.reloadData()
                }
            case .failure(let error):
                print("후기 불러오기 실패: \(error.localizedDescription)")
            }
        }
    }
}

extension OtherProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == otherProfileView.otherProfileBottomView.uploadPostView) {
            return otherPostsData.count
        } else if (tableView == otherProfileView.otherProfileBottomView.reviewTableView) {
            return otherReviewsData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == otherProfileView.otherProfileBottomView.uploadPostView) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
                return UITableViewCell()
            }
            cell.configure(model: otherPostsData[indexPath.row])
            return cell
            
        } else if (tableView == otherProfileView.otherProfileBottomView.reviewTableView) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.identifier, for: indexPath) as? ReviewCell else {
                return UITableViewCell()
            }
            cell.configure(model: otherReviewsData[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}
