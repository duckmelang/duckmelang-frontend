//
//  OtherPostsViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 2/21/25.
//

import UIKit
import Moya

class OtherPostsViewController: UIViewController {
    private let provider = MoyaProvider<OtherPageAPI>(plugins: [TokenPlugin(), NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    var otherPostsData: [PostDTO] = []
    var oppositeId: Int?
    
    var isLoading = false   // 중복 로딩 방지
    var isLastPage = false  // 마지막 페이지인지 여부
    var currentPage = 0     // 현재 페이지 번호
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = otherPostsView
        setupDelegate()
        getOtherPosts()
    }
    
    private lazy var otherPostsView = OtherPostsView()
    
    private func setupDelegate() {
        otherPostsView.uploadPostView.dataSource = self
        otherPostsView.uploadPostView.delegate = self
    }
    
    // MARK: - 게시글 가져오기
    private func getOtherPosts() {
        guard !isLoading && !isLastPage else { return } // 중복 호출 & 마지막 페이지 방지
        isLoading = true
        otherPostsView.loadingIndicator.startLoading()
        
        provider.request(.getOtherPosts(memberId: self.oppositeId!, page: currentPage)) { result in
            switch result {
            case .success(let response):
                DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                    let response = try? response.map(ApiResponse<PostResponse>.self)
                    guard let result = response?.result?.postList else { return }
                    guard let isLast = response?.result?.isLast else { return }
                    self.otherPostsData.append(contentsOf: result)
                    print("다른 사람 게시글: \(self.otherPostsData)")
                    
                    DispatchQueue.main.async {
                        self.otherPostsView.empty.isHidden = !result.isEmpty
                        self.isLastPage = isLast
                        self.isLoading = false
                        self.otherPostsView.loadingIndicator.stopLoading()
                        self.otherPostsView.uploadPostView.reloadData()
                        
                        if isLast {
                            self.otherPostsView.uploadPostView.tableFooterView = nil
                        }
                    }
                }
            case .failure(let error):
                print("게시글 불러오기 실패: \(error.localizedDescription)")
                self.isLoading = false
                self.otherPostsView.loadingIndicator.stopLoading()
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.frame.size.height

        if offsetY > contentHeight - tableViewHeight * 2 {
            if !isLoading && !isLastPage {
                currentPage += 1
                getOtherPosts()
            }
        }
    }
}
