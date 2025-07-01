//
//  PostDetailViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Moya
import SwiftyToaster

class OtherPostDetailViewController: UIViewController {
    var postId: Int?  // 전달받을 게시물 ID
    var postDetail: MyPostDetailResponse?
    
    var data = PostDetailAccompanyModel.dummy()
    
    private var accompanyData: [PostDetailAccompanyModel] = [] // 동행 정보 데이터

    let networkServiceMyPage = MyPageService()
    let networkServiceHome = HomeService()
    
    private lazy var isBookmarked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = otherPostDetailView
        otherPostDetailView.scrollView.isHidden = true
        
        startLoading()
        
        navigationController?.isNavigationBarHidden = true
        
        setupDelegate()
        
        otherPostDetailView.scrollView.delegate = self
        otherPostDetailView.translatesAutoresizingMaskIntoConstraints = true
        scrollViewDidScroll(otherPostDetailView.scrollView)
      
        // ✅ postId가 nil이 아니면 API 요청
        if let postId = postId {
            fetchPostDetail(postId: postId)
        } else {
            print("❌ postId가 nil입니다. API 호출을 하지 않습니다.")
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private lazy var otherPostDetailView = OtherPostDetailView().then {
        $0.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        $0.tabBar.scrapBtn.addTarget(self, action: #selector(scrapBtnDidTap), for: .touchUpInside)
        $0.tabBar.chatBtn.addTarget(self, action: #selector(chatBtnDidTap), for: .touchUpInside)
        $0.postDetailBottomView.warningBtn.addTarget(self, action: #selector(warningBtnDidTap), for: .touchUpInside)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        
        if yOffset < 0 {
            let scale = min(1 + abs(yOffset) / 300, 1.1)
            
            otherPostDetailView.imageViewTopConstraint.update(offset: yOffset)
            
            otherPostDetailView.imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
    
        } else {
            otherPostDetailView.imageView.transform = .identity
    
            otherPostDetailView.imageViewTopConstraint.update(offset: 0)
        }
    }
    
    @objc private func backBtnDidTap() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true) // ✅ 네비게이션이 있을 경우 pop 사용
        } else {
            dismiss(animated: true) // ✅ 네비게이션이 없으면 dismiss
        }
    }
    
    @objc private func warningBtnDidTap() {
        let VC = WarningViewController()
        self.navigationController?.pushViewController(VC, animated: true)
    }
 
    private func setupDelegate() {
        otherPostDetailView.postDetailBottomView.tableView.delegate = self
        otherPostDetailView.postDetailBottomView.tableView.dataSource = self
    }
    
    private func fetchPostDetail(postId: Int) {
        _Concurrency.Task {
            do {
                startLoading()
                
                let response = try await networkServiceMyPage.getMyPostDetail(postId: postId)
                self.postDetail = response
                DispatchQueue.main.async {
                    self.otherPostDetailView.updateUI(with: self.postDetail!)
                    self.updateAccompanyData(with: self.postDetail!)
                    self.updateBookmarkState(isBookmarked: self.postDetail!.bookmarkCount > 0) //북마크 상태 업데이트
                    self.updateScore(averageScore: self.postDetail!.averageScore) //점수 업데이트
                }
                //성공 시 데이터 출력
                print("Post Detail: \(response)")
                
                otherPostDetailView.scrollView.isHidden = false
                stopLoading()
            } catch {
                stopLoading()
                print(error.localizedDescription)
                Toaster.shared.makeToast("게시물 정보를 불러오지 못했습니다. \n 잠시 후 다시 시도해주세요.")
            }
        }
    }
    
    // ✅ 북마크 상태 업데이트 함수
    private func updateBookmarkState(isBookmarked: Bool) {
        self.isBookmarked = isBookmarked
        let imageName = isBookmarked ? "bookmark.fill" : "bookmark"
        otherPostDetailView.tabBar.scrapBtn.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    // ✅ 평균 점수 업데이트 함수
    private func updateScore(averageScore: Double) {
        otherPostDetailView.tabBar.score1.text = String(format: "%.1f", averageScore)
    }
    
    // ✅ 북마크 버튼 클릭 시 API 요청
    @objc private func scrapBtnDidTap() {
        guard let postId = postId else { return }
        addBookmark(postId: postId)
    }
    
    // ✅ 채팅 버튼 클릭 시 화면전환
    @objc private func chatBtnDidTap() {
        if let myId = KeychainManager.shared.load(key: "memberId") {
            if (postDetail?.memberId == Int(myId)) {
                let alert = UIAlertController(title: "경고", message: "나의 게시글에는 채팅을 보낼 수 없습니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
                return
            }
        }
        let newMessageVC = NewMessageViewController()
        newMessageVC.postId = postId
        newMessageVC.postDetail = postDetail
        navigationController?.pushViewController(newMessageVC, animated: true)
    }
    
    private func addBookmark(postId: Int) {
        _Concurrency.Task {
            do {
                startLoading()
                
                let _ = try await networkServiceHome.postBookmark(postId: postId)
                
                DispatchQueue.main.async {
                    self.otherPostDetailView.tabBar.scrapBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                }
                
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
                Toaster.shared.makeToast("북마크를 추가하는 데 실패했습니다. \n 잠시 후 다시 시도해주세요.")
            }
        }
    }
    
    // 동행 정보 데이터 가공
    private func updateAccompanyData(with detail: MyPostDetailResponse) {
        var models: [PostDetailAccompanyModel] = []
        
        models.append(PostDetailAccompanyModel(title: "아이돌", info: detail.idol.joined(separator: ", ")))
        models.append(PostDetailAccompanyModel(title: "행사 종류", info: detail.category))
        models.append(PostDetailAccompanyModel(title: "행사 날짜", info: detail.date))
        
        self.accompanyData = models
        self.otherPostDetailView.postDetailBottomView.tableView.reloadData()
    }
}

extension OtherPostDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accompanyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailAccompanyCell.identifier, for: indexPath) as? PostDetailAccompanyCell else {
            return UITableViewCell()
        }
        
        cell.configure(model: accompanyData[indexPath.row])
        return cell
    }
}
