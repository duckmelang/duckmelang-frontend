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
    
    @objc
    private func deleteBtnDidTap() {
        guard !selectedIndices.isEmpty else {
            // 선택된 셀이 없을 경우
            print("No selected row")
            return
        }
        
        // 선택된 indexPath들을 정렬하여 처리 (역순으로 삭제하면 index 문제가 발생하지 않음)
        let sortedIndices = selectedIndices.sorted { $0.row > $1.row }
        
        // 데이터 모델에서 제거
        for indexPath in sortedIndices {
            data.remove(at: indexPath.row)
        }
        
        // 테이블 뷰에서 제거
        feedManagementView.postView.deleteRows(at: sortedIndices, with: .automatic)
        
        // 선택 상태 초기화
        selectedIndices.removeAll()
    }
    
    @objc
    private func finishBtnDidTap() {
        // 선택된 IndexPath에 해당하는 데이터를 삭제
        selectedIndices.sorted(by: { $0.row > $1.row }).forEach { indexPath in
            data.remove(at: indexPath.row)
        }
        
        // 테이블 뷰 갱신
        feedManagementView.postView.reloadData()
        
        // 선택된 IndexPath 초기화
        selectedIndices.removeAll()
        
        feedManagementView.deleteBtn.isHidden = true
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
    
    // 내 게시글 가져오기
    private func fetchMyPosts() {
        provider.request(.getMyPosts(memberId: 1)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try response.map(ApiResponse<PostResponse>.self)
                    //디버깅용 데이터 출력 (서버 응답 확인)
                    print("📌 [DEBUG] 서버 응답 데이터:")
                    print(decodedResponse)
                    // `postList`가 `nil`이면 빈 배열을 할당하여 오류 방지
                    let postList = decodedResponse.result?.postList ?? []
                    
                    DispatchQueue.main.async {
                        self.posts = postList
                        self.feedManagementView.postView.reloadData() // 테이블뷰 갱신
                    }
                } catch {
                    print("JSON 디코딩 오류: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("게시글 불러오기 실패: \(error.localizedDescription)")
            }
        }
    }
}

extension FeedManagementViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
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
