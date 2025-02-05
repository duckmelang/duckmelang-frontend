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
       
    var otherPostsData: [PostDTO] = []
    var otherReviewsData: [OtherReviewDTO] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = otherProfileView
        
        navigationController?.isNavigationBarHidden = true
        otherProfileView.otherProfileBottomView.cosmosView.isHidden = true
        otherProfileView.otherProfileBottomView.cosmosStack.isHidden = true
        
        setupAction()
        setupDelegate()
        getProfileInfo()
        getOtherPosts()
    }

    private lazy var otherProfileView = OtherProfileView()
    
    @objc
    private func backBtnDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    @objc
    private func setBtnDidTap() {
        otherProfileView.otherProfileTopView.setBtnImage.isHidden = false
    }
    
    // setBtn 창 떠 있는 상태에서 다른 뷰를 누를때
    @objc
    private func viewDidTap() {
        if otherProfileView.otherProfileTopView.setBtnImage.isHidden == false {
            otherProfileView.otherProfileTopView.setBtnImage.isHidden = true
        }
    }*/

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
        /*otherProfileView. otherProfileTopView.setBtn.addTarget(self, action: #selector(setBtnDidTap), for: .touchUpInside)
        
        let setBtnDidTap = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        setBtnDidTap.numberOfTapsRequired = 1 // 단일 탭, 횟수 설정
        profileView.addGestureRecognizer(setBtnDidTap)
        
        let feedManagementDidTap = UITapGestureRecognizer(target: self, action: #selector(handleImageTap(_:)))
        profileView.profileTopView.setBtnImage.addGestureRecognizer(feedManagementDidTap)*/
    }
    
    /*@objc private func handleImageTap(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        
        // 터치한 위치 가져오기
        let touchPoint = sender.location(in: tappedView)
        
        // 이미지를 절반으로 나누기
        let halfHeight = tappedView.bounds.height / 2
        
        if touchPoint.y <= halfHeight {
            // 윗부분 터치
            let profileModifyVC = UINavigationController(rootViewController: ProfileModifyViewController())
            profileModifyVC.modalPresentationStyle = .fullScreen
            present(profileModifyVC, animated: false)
            profileView.profileTopView.setBtnImage.isHidden = true
        } else {
            // 아랫부분 터치
            let feedVC = UINavigationController(rootViewController: FeedManagementViewController())
            feedVC.modalPresentationStyle = .fullScreen
            present(feedVC, animated: false)
            profileView.profileTopView.setBtnImage.isHidden = true
        }
    }*/
    
    @objc private func segmentedControlValueChanged(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            otherProfileView.otherProfileBottomView.uploadPostView.isHidden = false
            otherProfileView.otherProfileBottomView.reviewTableView.isHidden = true
            otherProfileView.otherProfileBottomView.cosmosView.isHidden = true
            otherProfileView.otherProfileBottomView.cosmosStack.isHidden = true
            getOtherPosts()
        } else {
            otherProfileView.otherProfileBottomView.uploadPostView.isHidden = true
            otherProfileView.otherProfileBottomView.reviewTableView.isHidden = false
            otherProfileView.otherProfileBottomView.cosmosView.isHidden = false
            otherProfileView.otherProfileBottomView.cosmosStack.isHidden = false
            getOtherReviews()
        }
        
        let width = otherProfileView.otherProfileBottomView.segmentedControl.frame.width / CGFloat(otherProfileView.otherProfileBottomView.segmentedControl.numberOfSegments)
        let xPosition = otherProfileView.otherProfileBottomView.segmentedControl.frame.origin.x + (width * CGFloat(otherProfileView.otherProfileBottomView.segmentedControl.selectedSegmentIndex))
        
        UIView.animate(withDuration: 0.2) {
            self.otherProfileView.otherProfileBottomView.underLineView.frame.origin.x = xPosition
        }
    }
    
    private func getProfileInfo() {
        provider.request(.getOtherProfile(memberId: 1, page: 0)) { result in
            switch result {
            case .success(let response):
                let response = try? response.map(ApiResponse<OtherProfileData>.self)
                guard let profile = response?.result else { return }
                
                // OtherPageTopView에 데이터 반영
                DispatchQueue.main.async {
                    self.updateUI(profile)
                }
            case .failure(let error):
                print(" 프로필 불러오기 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateUI(_ profileData: OtherProfileData) {
        self.otherProfileView.otherProfileTopView.profileData = profileData
    }
    
    // 게시글 가져오기
    private func getOtherPosts() {
        provider.request(.getOtherPosts(memberId: 1, page: 0)) { result in
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
        provider.request(.getOtherReviews(memberId: 1)) { result in
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
