//
//  MyPostsViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/31/25.
//

import UIKit

class MyPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let networkService = MyAccompanyService()
    
    private var myPostsData: [PostDTO] = []
    
    var isLoading = false   // 중복 로딩 방지
    var totalPage = 0       // 마지막 페이지 번호
    var currentPage = 0     // 현재 페이지 번호
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = myPostsView
        setupDelegate()
        getMyPostsAPI(startPage: 0)
    }
    
    private lazy var myPostsView: MyPostsView = {
        let view = MyPostsView()
        return view
    }()

    private func setupDelegate() {
        myPostsView.myPostsTableView.delegate = self
        myPostsView.myPostsTableView.dataSource = self
    }
    
    private func getMyPostsAPI(startPage: Int) {
        Task {
            do {
                self.isLoading = true
                startLoading()
                
                let result = try await networkService.getMyPosts(page: startPage)
                
                if (result.isFirst) {
                    self.myPostsData = result.postList
                    self.totalPage = result.totalPage
                } else {
                    self.myPostsData.append(contentsOf: result.postList)
                }
//                self.currentPage = result.currentPage
                
                DispatchQueue.main.async {
                    self.myPostsView.empty.isHidden = !self.myPostsData.isEmpty
                    self.myPostsView.myPostsTableView.reloadData()
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
        return myPostsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        cell.configure(model: myPostsData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postId = myPostsData[indexPath.row].postId
        let myPostDetailVC = MyPostDetailViewController()
        
        myPostDetailVC.postId = postId
        
        self.navigationController?.pushViewController(myPostDetailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.frame.size.height

        if offsetY > contentHeight - tableViewHeight {
            guard !isLoading, currentPage + 1 < totalPage else { return }
            getMyPostsAPI(startPage: currentPage + 1)
        }
    }
}
