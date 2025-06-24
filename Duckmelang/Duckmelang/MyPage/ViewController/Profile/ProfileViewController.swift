//
//  ProfileViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Moya

class ProfileViewController: UIViewController{
    var selectedTag: Int = 0
    var profileData: ProfileData? //MyPage에서 전달받을 변수
    
    let networkService = MyPageService()

    private var posts: [PostDTO] = []
  
    //리뷰 데이터를 저장할 배열
    private var reviews: [myReviewDTO] = []
    
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
        fetchProfileData()
        
        profileView.profileTopView.isHidden = true
        
        fetchMyPosts()
        fetchReviews()
        
        // NotificationCenter 등록
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfile(_:)), name: NSNotification.Name("ProfileUpdated"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PostDeleted(_:)), name: NSNotification.Name("PostDeleted"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func updateProfile(_ notification: Notification) {
        print("📢 프로필 업데이트 알림 수신 - UI 업데이트")
        fetchProfileData()
    }
    
    @objc private func PostDeleted(_ notification: Notification) {
        fetchMyPosts()
        fetchProfileData()
    }
    
    private func fetchProfileData() {
        _Concurrency.Task {
            do {
                startLoading()
                
                let profile = try await networkService.getProfile()
                
                DispatchQueue.main.async {
                    self.profileData = profile
                    self.updateUI()
                }
                
                stopLoading()
            } catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }

    private lazy var profileView = ProfileView()
    private lazy var postDetailView = PostDetailView()
    
    private func updateUI() {
        if let profile = profileData {
            profileView.profileTopView.profileData = profile
            
            if let imageUrl = URL(string: "\(profile.latestPublicMemberProfileImage)?timestamp=\(Date().timeIntervalSince1970)") {
                profileView.profileTopView.profileImage.kf.setImage(with: imageUrl, options: [.cacheMemoryOnly])
            }
        }
        
        profileView.profileTopView.isHidden = false
    }
    
    // 내 게시글 가져오기
    private func fetchMyPosts() {
        _Concurrency.Task {
            do {
                startLoading()
                
                let postResponse = try await networkService.getMyPosts(page: 0)
                DispatchQueue.main.async {
                    self.posts = postResponse.postList
                    self.profileView.profileBottomView.uploadPostView.reloadData() // 테이블뷰 갱신
                }
                
                stopLoading()
            } catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchReviews() {
        _Concurrency.Task {
            do {
                startLoading()
                
                let reviewResponse = try await networkService.getReviews()
                DispatchQueue.main.async {
                    self.reviews = reviewResponse.reviewList
                    self.profileView.profileBottomView.reviewTableView.reloadData()
                    self.profileView.profileBottomView.cosmosView.rating = reviewResponse.average // ✅ 평점 업데이트
                    print("리뷰 \(reviewResponse.reviewList.count)개 로드됨")
                }
                
                stopLoading()
            } catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }


    @objc
    private func backBtnDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func setBtnDidTap() {
        profileView.profileTopView.setBtnImage.isHidden = false
    }
    
    @objc
    private func profileDidTap() {
        let VC = MyProfileImageViewController()
        VC.profileData = self.profileData
        self.navigationController?.pushViewController(VC, animated: true)
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
        setBtnDidTap.cancelsTouchesInView = false  // ✅ 터치 이벤트가 다른 뷰로 전달되도록 설정
        profileView.addGestureRecognizer(setBtnDidTap)
        
        let feedManagementDidTap = UITapGestureRecognizer(target: self, action: #selector(handleImageTap(_:)))
        profileView.profileTopView.setBtnImage.addGestureRecognizer(feedManagementDidTap)
        
        let profileDidTap = UITapGestureRecognizer(target: self, action: #selector(profileDidTap))
        profileDidTap.numberOfTapsRequired = 1
        //profileDidTap.cancelsTouchesInView = false
        profileView.profileTopView.profileImage.addGestureRecognizer(profileDidTap)
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
            return posts.isEmpty ? 0 : posts.count
        } else if (tableView == profileView.profileBottomView.reviewTableView) {
            return reviews.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == profileView.profileBottomView.uploadPostView) {
            guard !posts.isEmpty else { return UITableViewCell() } //데이터 없을 때 기본 셀 반환
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
                return UITableViewCell()
            }
            
            //posts 배열에서 해당 인덱스의 데이터를 가져와 전달
            let post = posts[indexPath.row]
            cell.configure(model: post)
            
            //디버깅용 데이터 출력
            print("📌 [DEBUG] configure()에 전달되는 Post 데이터:")
            print("📌 postId: \(post.postId), title: \(post.title), category: \(post.category)")
            print("📌 date: \(post.date), nickname: \(post.nickname), createdAt: \(post.createdAt)")
            print("📌 postImageUrl: \(post.postImageUrl), latestProfileImage: \(post.latestPublicMemberProfileImage)")
            
            return cell
            
        } else if (tableView == profileView.profileBottomView.reviewTableView) {
            guard !reviews.isEmpty else { return UITableViewCell() }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.identifier, for: indexPath) as? ReviewCell else {
                return UITableViewCell()
            }
            
            let review = reviews[indexPath.row]
            cell.configure(model: review)
            
            //데이터 출력
            print("📝 [ReviewCell] 셀 \(indexPath.row + 1) 데이터 설정:")
            print("   - 닉네임: \(review.nickname)")
            print("   - 성별: \(review.gender == "true" ? "남성" : "여성")")
            print("   - 나이: \(review.age)")
            print("   - 내용: \(review.content)")
            print("   - 점수: \(review.score)")
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("📌 didSelectRowAt 호출됨 - IndexPath: \(indexPath.row)")

        if tableView == profileView.profileBottomView.uploadPostView {
            print("📌 게시물 선택됨 - Post ID: \(posts[indexPath.row].postId)")

            let post = posts[indexPath.row]  // 선택한 게시물 가져오기
           
            // PostDetailViewController로 postId 전달
            let postDetailVC = PostDetailViewController()
            postDetailVC.postId = post.postId  // PostDetailViewController에 postId 설정
            // ✅ 네비게이션 스택을 사용하여 푸시 (기존 present 방식에서 변경)
            self.navigationController?.pushViewController(postDetailVC, animated: true)
        }
    }

}
