//
//  ProfileViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class ProfileViewController: UIViewController{
    var selectedTag: Int = 0
    var profileData: ProfileData? //MyPage에서 전달받을 변수
       
    let data1 = PostModel.dummy1()

    let data2 = ReviewModel.dummy()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = profileView
        
        navigationController?.isNavigationBarHidden = true
        profileView.profileBottomView.cosmosView.isHidden = true
        profileView.profileBottomView.cosmosStack.isHidden = true
        
        setupAction()
        setupDelegate()
        updateUI()
    }

    private lazy var profileView = ProfileView()
    
    private func updateUI() {
        if let profile = profileData { //MyPage에서 전달받은 데이터 적용
            profileView.profileTopView.profileData = profile
        }
    }
    
    @objc
    private func backBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    @objc
    private func setBtnDidTap() {
        profileView.profileTopView.setBtnImage.isHidden = false
    }
    
    // setBtn 창 떠 있는 상태에서 다른 뷰를 누를때
    @objc
    private func viewDidTap() {
        if profileView.profileTopView.setBtnImage.isHidden == false {
            profileView.profileTopView.setBtnImage.isHidden = true
        }
    }

    private func setupDelegate() {
        profileView.profileBottomView.uploadPostView.dataSource = self
        profileView.profileBottomView.uploadPostView.delegate = self
        
        profileView.profileBottomView.reviewTableView.dataSource = self
        profileView.profileBottomView.reviewTableView.delegate = self
    }
    
    private func setupAction() {
        profileView.profileTopView.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        // segmentedControl
        profileView.profileBottomView.segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(segment:)), for: .valueChanged)
        profileView.profileTopView.setBtn.addTarget(self, action: #selector(setBtnDidTap), for: .touchUpInside)
        
        let setBtnDidTap = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        setBtnDidTap.numberOfTapsRequired = 1 // 단일 탭, 횟수 설정
        profileView.addGestureRecognizer(setBtnDidTap)
        
        let feedManagementDidTap = UITapGestureRecognizer(target: self, action: #selector(handleImageTap(_:)))
        profileView.profileTopView.setBtnImage.addGestureRecognizer(feedManagementDidTap)
    }
    
    @objc private func handleImageTap(_ sender: UITapGestureRecognizer) {
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
    }
    
    @objc private func segmentedControlValueChanged(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            profileView.profileBottomView.uploadPostView.isHidden = false
            profileView.profileBottomView.reviewTableView.isHidden = true
            profileView.profileBottomView.cosmosView.isHidden = true
            profileView.profileBottomView.cosmosStack.isHidden = true
        } else {
            profileView.profileBottomView.uploadPostView.isHidden = true
            profileView.profileBottomView.reviewTableView.isHidden = false
            profileView.profileBottomView.cosmosView.isHidden = false
            profileView.profileBottomView.cosmosStack.isHidden = false
        }
        
        let width = profileView.profileBottomView.segmentedControl.frame.width / CGFloat(profileView.profileBottomView.segmentedControl.numberOfSegments)
        let xPosition = profileView.profileBottomView.segmentedControl.frame.origin.x + (width * CGFloat(profileView.profileBottomView.segmentedControl.selectedSegmentIndex))
        
        UIView.animate(withDuration: 0.2) {
            self.profileView.profileBottomView.underLineView.frame.origin.x = xPosition
        }
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == profileView.profileBottomView.uploadPostView) {
            return data1.count
        } else if (tableView == profileView.profileBottomView.reviewTableView) {
            return data2.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if (tableView == profileView.profileBottomView.uploadPostView) {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
                    return UITableViewCell()
                }
                cell.configure(model: data1[indexPath.row])
                return cell
                
            } else if (tableView == profileView.profileBottomView.reviewTableView) {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.identifier, for: indexPath) as? ReviewCell else {

                    return UITableViewCell()
                }
                cell.configure(model: data2[indexPath.row])
                return cell
            }
            
            return UITableViewCell()
        }
}
