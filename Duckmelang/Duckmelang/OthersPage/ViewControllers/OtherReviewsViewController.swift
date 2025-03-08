//
//  OtherReviewsViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 2/21/25.
//

import UIKit
import Moya

class OtherReviewsViewController: UIViewController {
    private let provider = MoyaProvider<OtherPageAPI>(plugins: [TokenPlugin(), NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    var otherReviewsData: [OtherReviewDTO] = []
    var oppositeId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = otherReviewsView
        setupDelegate()
        getOtherReviews()
    }
    
    private lazy var otherReviewsView = OtherReviewsView()

    private func setupDelegate() {
        otherReviewsView.reviewTableView.dataSource = self
        otherReviewsView.reviewTableView.delegate = self
    }
    
    // MARK: - 후기 가져오기
    private func getOtherReviews() {
        provider.request(.getOtherReviews(memberId: self.oppositeId!)) { result in
            switch result {
            case .success(let response):
                self.otherReviewsData.removeAll()
                let response = try? response.map(ApiResponse<OtherReviewResponse>.self)
                guard let result = response?.result else { return }
                self.otherReviewsData = result.reviewList
                
                print("다른 사람 후기: \(self.otherReviewsData)")
                DispatchQueue.main.async {
                    self.otherReviewsView.cosmosView.rating = result.average
                    self.otherReviewsView.cosmosCount.text = "\(result.average)"
                    self.otherReviewsView.reviewTableView.reloadData()
                }
            case .failure(let error):
                print("후기 불러오기 실패: \(error.localizedDescription)")
            }
        }
    }
}

extension OtherReviewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return otherReviewsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.identifier, for: indexPath) as? ReviewCell else {
            return UITableViewCell()
        }
        cell.configure(model: otherReviewsData[indexPath.row])
        return cell
    }
}
