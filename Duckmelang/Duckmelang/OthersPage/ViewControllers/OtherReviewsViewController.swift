//
//  OtherReviewsViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 2/21/25.
//

import UIKit

class OtherReviewsViewController: UIViewController {
    let networkService = OtherPageService()
    
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
        Task {
            do {
                startLoading()
                self.otherReviewsData.removeAll()
                guard let oppositeId = self.oppositeId else { return }
                
                let result = try await networkService.getOtherReviews(memberId: oppositeId)
                self.otherReviewsData = result.reviewList
                
                // OtherPageTopView에 데이터 반영
                DispatchQueue.main.async {
                    self.otherReviewsView.cosmosView.rating = result.average
                    self.otherReviewsView.cosmosCount.text = "\(result.average)"
                    self.otherReviewsView.reviewTableView.reloadData()
                }
                
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
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
