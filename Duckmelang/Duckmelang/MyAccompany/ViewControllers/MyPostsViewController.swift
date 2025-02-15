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
        provider.request(.getMyPosts(page: 0)) { result in
            switch result {
            case .success(let response):
                self.myPostsData.removeAll()
                let response = try? response.map(ApiResponse<PostResponse>.self)
                guard let result = response?.result?.postList else { return }
                self.myPostsData = result
                print("내 게시글: \(self.myPostsData)")
                DispatchQueue.main.async {
                    self.myPostsView.myPostsTableView.reloadData()
                }
            case .failure(let error):
                print(error)
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
}
