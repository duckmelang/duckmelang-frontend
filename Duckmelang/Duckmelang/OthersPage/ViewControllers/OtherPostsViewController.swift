//
//  OtherPostsViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 2/21/25.
//

import UIKit

class OtherPostsViewController: UIViewController {
    let networkService = OtherPageService()
    
    var otherPostsData: [PostDTO] = []
    var oppositeId: Int?
    
    var isLoading = false   // 중복 로딩 방지
    var totalPage = 0       // 마지막 페이지 번호
    var currentPage = 0     // 현재 페이지 번호
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = otherPostsView
        setupDelegate()
        getOtherPosts(startPage: 0)
    }
    
    private lazy var otherPostsView = OtherPostsView()
    
    private func setupDelegate() {
        otherPostsView.uploadPostView.dataSource = self
        otherPostsView.uploadPostView.delegate = self
    }
    
    // MARK: - 게시글 가져오기
    private func getOtherPosts(startPage: Int) {
        Task {
            do {
                self.isLoading = true
                startLoading()
                guard let oppositeId = oppositeId else { return }
                
                let result = try await networkService.getOtherPosts(memberId: oppositeId, page: startPage)
                
                if (result.isFirst) {
                    self.otherPostsData = result.postList
                    self.totalPage = result.totalPage
                } else {
                    self.otherPostsData.append(contentsOf: result.postList)
                }
                self.currentPage = result.currentPage
                
                DispatchQueue.main.async {
                    self.otherPostsView.empty.isHidden = !self.otherPostsData.isEmpty
                    self.otherPostsView.uploadPostView.reloadData()
                }
                
                stopLoading()
                isLoading = false
            }
            catch {
                stopLoading()
                isLoading = false
                print(error.localizedDescription)
            }
        }
    }
}

extension OtherPostsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return otherPostsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        cell.configure(model: otherPostsData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postId = otherPostsData[indexPath.row].postId
        let detailVC = OtherPostDetailViewController()
        
        detailVC.postId = postId
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.frame.size.height

        if offsetY > contentHeight - tableViewHeight {
            guard !isLoading, currentPage + 1 < totalPage else { return }
            getOtherPosts(startPage: currentPage + 1)
        }
    }
}
