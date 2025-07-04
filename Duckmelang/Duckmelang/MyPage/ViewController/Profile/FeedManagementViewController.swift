//
//  FeedManagementViewController.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import Moya
import SwiftyToaster

class FeedManagementViewController: UIViewController {
    
    var data = FeedManagementModel.dummy()
    
    var selectedIndices: Set<IndexPath> = [] // 선택된 셀의 indexPath를 저장
    
    private var pendingDeletes: [(postId: Int, indexPath: IndexPath)] = [] // 삭제 대기 중인 게시물 저장
    
    let networkService = MyPageService()

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
        self.navigationController?.popViewController(animated: true)
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
                    
                    NotificationCenter.default.post(name: NSNotification.Name("PostDeleted"), object: nil)
                }
            }
            
            self.navigationController?.popViewController(animated: true)
        }

        /// ✅ 서버에서 게시물 삭제 요청
        private func deletePost(postId: Int, completion: (() -> Void)? = nil) {
            _Concurrency.Task {
                do {
                    let response: () = try await networkService.deletePost(postId: postId)
                    print("게시글 삭제 성공: \(response)")
                } catch {
                    print(error.localizedDescription)
                }
                completion?()
            }
        }

        /// ✅ 최신 게시물 가져오기 (삭제된 게시물 제외)
        private func fetchMyPosts() {
            _Concurrency.Task {
                do {
                    startLoading()
                    
                    let response = try await networkService.getMyPosts(page: 0)
                    let deletedPostIds = self.pendingDeletes.map { $0.postId }
                    let filteredPosts = response.postList.filter { !deletedPostIds.contains($0.postId) }
                    
                    DispatchQueue.main.async {
                        self.posts = filteredPosts
                        self.feedManagementView.postView.reloadData()
                    }
                    
                    stopLoading()
                    Toaster.shared.makeToast("게시글이 삭제되었습니다.")
                } catch {
                    stopLoading()
                    print(error.localizedDescription)
                    Toaster.shared.makeToast("게시글 삭제에 실패했습니다. \n 다시 시도해주세요")
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
        
        let post = posts[indexPath.row]
        let isSelected = selectedIndices.contains(indexPath)
        cell.configure(model: post, isSelected: isSelected)
        
        // ✅ 버튼을 눌렀을 때도 선택/해제 기능 추가
        cell.selectBtn.addTarget(self, action: #selector(toggleSelection(_:)), for: .touchUpInside)
        cell.selectBtn.tag = indexPath.row
        
        
        return cell
    }
    
    // ✅ 버튼을 눌러도 셀 선택이 되도록 처리
    @objc private func toggleSelection(_ sender: UIButton) {
        let row = sender.tag
        let indexPath = IndexPath(row: row, section: 0)
        toggleCellSelection(at: indexPath)
    }
    
    func toggleCellSelection(at indexPath: IndexPath) {
        if let cell = feedManagementView.postView.cellForRow(at: indexPath) as? FeedManagementCell {
            if selectedIndices.contains(indexPath) {
                selectedIndices.remove(indexPath)
                cell.selectBtn.setImage(UIImage(resource: .noSelect), for: .normal)
                cell.contentView.backgroundColor = .clear
            } else {
                selectedIndices.insert(indexPath)
                cell.selectBtn.setImage(UIImage(resource: .select), for: .normal)
                cell.contentView.backgroundColor = .grey100
            }
            // delete 버튼 상태 업데이트
            feedManagementView.deleteBtn.isHidden = selectedIndices.isEmpty
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? FeedManagementCell {
            toggleCellSelection(at: indexPath)
        }
    }
}
