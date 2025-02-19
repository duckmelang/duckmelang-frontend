//
//  FeedManagementViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Moya

class FeedManagementViewController: UIViewController {
    
    var data = FeedManagementModel.dummy()
    
    var selectedIndices: Set<IndexPath> = [] // 선택된 셀의 indexPath를 저장
    
    private var pendingDeletes: [(postId: Int, indexPath: IndexPath)] = [] // 삭제 대기 중인 게시물 저장
    
    private let provider = MoyaProvider<MyPageAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])

    private var posts: [PostDTO] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = feedManagementView
        
        navigationController?.isNavigationBarHidden = true
        
        setupDelegate()
        setupAction()
        fetchMyPosts()
    }
    
    private lazy var feedManagementView = FeedManagementView()

    @objc
    private func backBtnDidTap() {
        self.presentingViewController?.dismiss(animated: false)
    }
    
    /// ✅ 삭제 버튼 클릭: UI에서만 삭제 (서버 요청 X)
        @objc private func deleteBtnDidTap() {
            guard !selectedIndices.isEmpty else {
                print("❌ 선택된 게시물이 없습니다.")
                return
            }

            let sortedIndices = selectedIndices.sorted { $0.row > $1.row }

            feedManagementView.postView.performBatchUpdates({
                for indexPath in sortedIndices {
                    if indexPath.row < posts.count {
                        let postId = posts[indexPath.row].postId
                        pendingDeletes.append((postId: postId, indexPath: indexPath)) // 대기열에 추가
                        posts.remove(at: indexPath.row) // UI에서 제거
                        feedManagementView.postView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }, completion: { _ in
                self.selectedIndices.removeAll()
                self.feedManagementView.deleteBtn.isHidden = true
                print("🕒 삭제 대기 상태: \(self.pendingDeletes)")
            })
        }

        /// ✅ finish 버튼 클릭: 서버에서 실제로 삭제 요청
        @objc private func finishBtnDidTap() {
            guard !pendingDeletes.isEmpty else {
                print("✅ 삭제할 게시물이 없습니다.")
                return
            }

            let dispatchGroup = DispatchGroup()

            for (postId, _) in pendingDeletes {
                dispatchGroup.enter()
                deletePost(postId: postId) {
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                print("✅ 모든 삭제 요청 완료됨, 서버에서 최신 데이터 다시 불러오기")
                DispatchQueue.main.async {
                    self.fetchMyPosts() // 서버에서 최신 데이터 다시 불러옴
                    self.pendingDeletes.removeAll() // 삭제 완료 후 대기열 초기화
                }
            }
        }

        /// ✅ 서버에서 게시물 삭제 요청
        private func deletePost(postId: Int, completion: (() -> Void)? = nil) {
            provider.request(.deletePost(postId: postId)) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try response.map(ApiResponse<String>.self)
                        if decodedResponse.isSuccess {
                            print("✅ 게시물 삭제 성공: \(decodedResponse.message)")
                        } else {
                            print("❌ 삭제 실패: \(decodedResponse.message)")
                        }
                    } catch {
                        print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("❌ 요청 실패: \(error.localizedDescription)")
                }
                completion?() // 요청이 끝난 후 처리
            }
        }

        /// ✅ 최신 게시물 가져오기 (삭제된 게시물 제외)
        private func fetchMyPosts() {
            provider.request(.getMyPosts(page: 0)) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try response.map(ApiResponse<PostResponse>.self)

                        // ✅ 서버에서 최신 게시물 가져오기, 삭제된 postId 제외
                        let allPosts = decodedResponse.result?.postList ?? []
                        let deletedPostIds = self.pendingDeletes.map { $0.postId }
                        let filteredPosts = allPosts.filter { !deletedPostIds.contains($0.postId) }

                        DispatchQueue.main.async {
                            self.posts = filteredPosts
                            self.feedManagementView.postView.reloadData()
                        }

                    } catch {
                        print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("❌ 게시글 불러오기 실패: \(error.localizedDescription)")
                }
            }
        }

    /// ✅ 뷰가 다시 나타날 때 삭제된 상태 유지
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMyPosts() // ✅ 최신 데이터 가져오면서 삭제된 항목 반영
    }


    
    private func setupDelegate() {
        feedManagementView.postView.dataSource = self
        feedManagementView.postView.delegate = self
    }
    
    private func setupAction() {
        feedManagementView.backBtn.addTarget(self, action: #selector(backBtnDidTap), for: .touchUpInside)
        feedManagementView.finishBtn.addTarget(self, action: #selector(finishBtnDidTap), for: .touchUpInside)
        feedManagementView.deleteBtn.addTarget(self, action: #selector(deleteBtnDidTap), for: .touchUpInside)
    }
    
    private func deletePost(postId: Int, indexPath: IndexPath) {
        provider.request(.deletePost(postId: postId)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try response.map(ApiResponse<String>.self)
                    if decodedResponse.isSuccess {
                        print("✅ 게시물 삭제 성공: \(decodedResponse.message)")
                    } else {
                        print("❌ 삭제 실패: \(decodedResponse.message)")
                    }
                } catch {
                    print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("❌ 요청 실패: \(error.localizedDescription)")
            }
        }
    }
}

extension FeedManagementViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.isEmpty ? 0 : posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !posts.isEmpty else { return UITableViewCell() } //데이터 없을 때 기본 셀 반환
            
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedManagementCell.identifier, for: indexPath) as? FeedManagementCell else {
            return UITableViewCell()
        }
        
        //posts 배열에서 해당 인덱스의 데이터를 가져와 전달
        let post = posts[indexPath.row]
        cell.configure(model: post)
        
        //디버깅용 데이터 출력
        print("📌 [DEBUG] configure()에 전달되는 Post 데이터:")
        print("📌 postId: \(post.postId), title: \(post.title), category: \(post.category)")
        print("📌 postImageUrl: \(post.postImageUrl), latestProfileImage: \(post.latestPublicMemberProfileImage)")
        
        // 셀이 선택된 상태인지 확인
        if selectedIndices.contains(indexPath) {
            cell.selectBtn.isSelected = true
            cell.selectBtn.setImage(.select, for: .normal)
            cell.contentView.backgroundColor = .grey100
        } else {
            cell.selectBtn.isSelected = false
            cell.selectBtn.setImage(.noSelect, for: .normal)
            cell.contentView.backgroundColor = .clear
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FeedManagementCell {
            // 선택된 셀을 토글
            if selectedIndices.contains(indexPath) {
                // 이미 선택된 경우, 선택 해제
                selectedIndices.remove(indexPath)
                cell.selectBtn.isSelected = false
                cell.selectBtn.setImage(.noSelect, for: .normal)
                cell.contentView.backgroundColor = .clear
            } else {
                // 새로 선택된 경우
                selectedIndices.insert(indexPath)
                cell.selectBtn.isSelected = true
                cell.selectBtn.setImage(.select, for: .normal)
                cell.contentView.backgroundColor = .grey100
            }
            
            // delete 버튼 상태 업데이트
            feedManagementView.deleteBtn.isHidden = selectedIndices.isEmpty
        }
    }
}
