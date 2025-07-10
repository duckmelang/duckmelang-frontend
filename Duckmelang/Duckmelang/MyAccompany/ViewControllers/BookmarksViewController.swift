//
//  BookmarksViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/31/25.
//

import UIKit

class BookmarksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let networkService = MyAccompanyService()
    
    private var bookmarksData: [PostDTO] = []
    
    var isLoading = false   // 중복 로딩 방지
    var totalPage = 0       // 마지막 페이지 번호
    var currentPage = 0     // 현재 페이지 번호
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = bookmarksView
        setupDelegate()
        getBookmarksAPI(startPage: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadBookmarks), name: .bookmarkDidChange, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private lazy var bookmarksView = BookmarksView()

    private func setupDelegate() {
        bookmarksView.bookmarksTableView.delegate = self
        bookmarksView.bookmarksTableView.dataSource = self
    }
    
    @objc
    private func reloadBookmarks() {
        getBookmarksAPI(startPage: 0) // 다시 처음부터 새로 불러오기
    }
    
    private func getBookmarksAPI(startPage: Int) {
        Task {
            do {
                self.isLoading = true
                startLoading()
                
                let result = try await networkService.getBookmarks(page: startPage)
                
                if (result.isFirst) {
                    self.bookmarksData = result.bookmarkList.map { $0.post }
                    self.totalPage = result.totalPage
                } else {
                    self.bookmarksData.append(contentsOf: result.bookmarkList.map { $0.post })
                }
                self.currentPage = result.currentPage
                
                DispatchQueue.main.async {
                    self.bookmarksView.empty.isHidden = !self.bookmarksData.isEmpty
                    self.bookmarksView.bookmarksTableView.reloadData()
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
        let bookmarkDetailVC = OtherPostDetailViewController()
        
        bookmarkDetailVC.postId = postId
        
        self.navigationController?.pushViewController(bookmarkDetailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.frame.size.height

        if offsetY > contentHeight - tableViewHeight {
            guard !isLoading, currentPage + 1 < totalPage else { return }
            getBookmarksAPI(startPage: currentPage + 1)
        }
    }
}
