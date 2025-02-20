//
//  MyPostsViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/31/25.
//

import UIKit
import Moya

class MyPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let provider = MoyaProvider<MyAccompanyAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private var myPostsData: [PostDTO] = []
    
    var isLoading = false   // 중복 로딩 방지
    var isLastPage = false  // 마지막 페이지인지 여부
    var currentPage = 0     // 현재 페이지 번호
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = myPostsView
        setupDelegate()
        getMyPostsAPI()
    }
    
    private lazy var myPostsView: MyPostsView = {
        let view = MyPostsView()
        return view
    }()

    private func setupDelegate() {
        myPostsView.myPostsTableView.delegate = self
        myPostsView.myPostsTableView.dataSource = self
    }

    private func getMyPostsAPI() {
        guard !isLoading && !isLastPage else { return } // 중복 호출 & 마지막 페이지 방지
        isLoading = true
        myPostsView.loadingIndicator.startLoading()
        
        provider.request(.getMyPosts(page: currentPage)) { result in
            switch result {
            case .success(let response):
                DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                    let response = try? response.map(ApiResponse<PostResponse>.self)
                    guard let result = response?.result?.postList else { return }
                    guard let isLast = response?.result?.isLast else { return }
                    self.myPostsData.append(contentsOf: result)
                    print("내 게시글: \(self.myPostsData)")
                    
                    DispatchQueue.main.async {
                        self.myPostsView.empty.isHidden = !result.isEmpty
                        self.isLastPage = isLast
                        self.isLoading = false
                        self.myPostsView.loadingIndicator.stopLoading()
                        self.myPostsView.myPostsTableView.reloadData()
                        
                        if isLast {
                            self.myPostsView.myPostsTableView.tableFooterView = nil
                        }
                    }
                }
            case .failure(let error):
                print(error)
                self.isLoading = false
                self.myPostsView.loadingIndicator.stopLoading()
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

        if offsetY > contentHeight - tableViewHeight * 2 {
            if !isLoading && !isLastPage {
                currentPage += 1
                getMyPostsAPI()
            }
        }
    }
}
