//
//  BookmarksViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/31/25.
//

import UIKit
import Moya

class BookmarksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let provider = MoyaProvider<MyAccompanyAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private var bookmarksData: [PostDTO] = []
    
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
        provider.request(.getBookmarks(memberId: 1, page: 0)) { result in
            switch result {
            case .success(let response):
                self.bookmarksData.removeAll()
                let response = try? response.map(ApiResponse<PostResponse>.self)
                guard let result = response?.result?.postList else { return }
                self.bookmarksData = result
                print("스크랩: \(self.bookmarksData)")
                DispatchQueue.main.async {
                    self.bookmarksView.bookmarksTableView.reloadData()
                }
            case .failure(let error):
                print(error)
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
}
