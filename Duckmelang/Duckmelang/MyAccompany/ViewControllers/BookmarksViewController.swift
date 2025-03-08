//
//  BookmarksViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/31/25.
//

import UIKit
import Moya

class BookmarksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let provider = MoyaProvider<MyAccompanyAPI>(plugins: [TokenPlugin(), NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private var bookmarksData: [PostDTO] = []
    
    var isLoading = false   // 중복 로딩 방지
    var isLastPage = false  // 마지막 페이지인지 여부
    var currentPage = 0     // 현재 페이지 번호
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = bookmarksView
        setupDelegate()
        getBookmarksAPI()
    }
    
    private lazy var bookmarksView: BookmarksView = {
        let view = BookmarksView()
        return view
    }()

    private func setupDelegate() {
        bookmarksView.bookmarksTableView.delegate = self
        bookmarksView.bookmarksTableView.dataSource = self
    }

    private func getBookmarksAPI() {
        guard !isLoading && !isLastPage else { return } // 중복 호출 & 마지막 페이지 방지
        isLoading = true
        bookmarksView.loadingIndicator.startLoading()
        
        provider.request(.getBookmarks(page: currentPage)) { result in
            switch result {
            case .success(let response):
                DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                    let response = try? response.map(ApiResponse<PostResponse>.self)
                    guard let result = response?.result?.postList else { return }
                    guard let isLast = response?.result?.isLast else { return }
                    self.bookmarksData.append(contentsOf: result)
                    print("스크랩: \(self.bookmarksData)")
                    
                    DispatchQueue.main.async {
                        self.bookmarksView.empty.isHidden = !result.isEmpty
                        self.isLastPage = isLast
                        self.isLoading = false
                        self.bookmarksView.loadingIndicator.stopLoading()
                        self.bookmarksView.bookmarksTableView.reloadData()
                        
                        if isLast {
                            self.bookmarksView.bookmarksTableView.tableFooterView = nil
                        }
                    }
                }
            case .failure(let error):
                print(error)
                self.isLoading = false
                self.bookmarksView.loadingIndicator.stopLoading()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarksData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        cell.configure(model: bookmarksData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postId = bookmarksData[indexPath.row].postId
        let bookmarkDetailVC = BookmarkDetailViewController()
        
        bookmarkDetailVC.postId = postId
        
        self.navigationController?.pushViewController(bookmarkDetailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.frame.size.height

        if offsetY > contentHeight - tableViewHeight * 2 {
            if !isLoading && !isLastPage {
                currentPage += 1
                getBookmarksAPI()
            }
        }
    }
}
