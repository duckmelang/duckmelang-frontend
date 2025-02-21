//
//  PostDetailViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Moya

class OtherPostDetailViewController: UIViewController {
    var postId: Int?  // 전달받을 게시물 ID
    
    var data = PostDetailAccompanyModel.dummy()
    
    private var accompanyData: [PostDetailAccompanyModel] = [] // 동행 정보 데이터

    private let provider = MoyaProvider<MyPageAPI>(plugins: [TokenPlugin(), NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private let providerHome = MoyaProvider<HomeAPI>(plugins: [TokenPlugin(), NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private let providerOther = MoyaProvider<OtherPageAPI>(plugins: [TokenPlugin(), NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    private lazy var isBookmarked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = otherPostDetailView
        
        navigationController?.isNavigationBarHidden = true
        
        setupDelegate()
 
        // ✅ postId가 nil이 아니면 API 요청
        if let postId = postId {
            fetchPostDetail(postId: postId)
        } else {
            print("❌ postId가 nil입니다. API 호출을 하지 않습니다.")
        }
    }
    
    private lazy var otherPostDetailView = OtherPostDetailView().then {
        $0.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        $0.tabBar.scrapBtn.addTarget(self, action: #selector(scrapBtnDidTap), for: .touchUpInside)
    }

    @objc private func backBtnDidTap() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true) // ✅ 네비게이션이 있을 경우 pop 사용
        } else {
            dismiss(animated: true) // ✅ 네비게이션이 없으면 dismiss
        }
    }
 
    private func setupDelegate() {
        otherPostDetailView.postDetailBottomView.tableView.delegate = self
        otherPostDetailView.postDetailBottomView.tableView.dataSource = self
    }
    
    private func fetchPostDetail(postId: Int) {
        provider.request(.getMyPostDetail(postId: postId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try response.map(ApiResponse<MyPostDetailResponse>.self)
                    if decodedResponse.isSuccess {
                        guard let postDetail = decodedResponse.result else { return }
                        DispatchQueue.main.async {
                            self.otherPostDetailView.updateUI(with: postDetail)
                            self.updateAccompanyData(with: postDetail)
                            self.updateBookmarkState(isBookmarked: postDetail.bookmarkCount > 0) // ✅ 북마크 상태 업데이트
                            self.updateScore(averageScore: postDetail.averageScore) // ✅ 점수 업데이트
                            
                        }
                        // ✅ 성공 시 데이터 출력
                        print("Post Detail: \(String(describing: decodedResponse.result))")
                    } else {
                        print("❌ 서버 에러: \(decodedResponse.message)")
                    }
                } catch {
                    print("❌ JSON 디코딩 실패: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("❌ 요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    // ✅ 북마크 상태 업데이트 함수
    private func updateBookmarkState(isBookmarked: Bool) {
        self.isBookmarked = isBookmarked
        let imageName = isBookmarked ? "bookmark.fill" : "bookmarks"
        otherPostDetailView.tabBar.scrapBtn.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    // ✅ 평균 점수 업데이트 함수
    private func updateScore(averageScore: Double) {
        otherPostDetailView.tabBar.score1.text = String(format: "%.1f", averageScore)
    }
    
    // ✅ 북마크 버튼 클릭 시 API 요청
    @objc private func scrapBtnDidTap() {
        guard let postId = postId else { return }
        
        addBookmark(postId: postId) { success in
            if success {
                DispatchQueue.main.async {
                    self.otherPostDetailView.tabBar.scrapBtn.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                }
            }
        }
    }
    
    func addBookmark(postId: Int, completion: @escaping (Bool) -> Void) {
        providerHome.request(.postBookmark(postId: postId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(BookmarkResponse.self, from: response.data)
                    if decodedResponse.isSuccess {
                        print("✅ 북마크 추가 성공 - 북마크 ID: \(decodedResponse.result?.bookmarkId ?? 0)")
                        completion(true)
                    } else {
                        print("❌ 북마크 추가 실패: \(decodedResponse.message)")
                        completion(false)
                    }
                } catch {
                    print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
                    completion(false)
                }
            case .failure(let error):
                print("❌ 북마크 API 요청 실패: \(error.localizedDescription)")
                completion(false)
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
