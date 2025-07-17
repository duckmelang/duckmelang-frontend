//
//  RequestViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/31/25.
//

import UIKit

class RequestViewController: UIViewController {
    let networkService = MyAccompanyService()
    
    private var requestData: [RequestDTO] = []
    
    var selectedTag: Int = 0
    var status: String = ""
    
    var isLoading = false          // 중복 로딩 방지
    var totalPage = [0, 0, 0]      // 마지막 페이지 번호
    var currentPage = [0, 0, 0]    // 현재 페이지 번호
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = requestView
        setupDelegate()
        setupAction()
        updateBtnSelected()
        fetchRequestAPI(startPage: 0)
    }
    
    private lazy var requestView: RequestView = {
        let view = RequestView()
        return view
    }()

    private func setupDelegate() {
        requestView.requestTableView.delegate = self
        requestView.requestTableView.dataSource = self
    }
    
    private func setupAction() {
        requestView.sentBtn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        requestView.awaitingBtn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        requestView.receivedBtn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
    }
    
    @objc private func clickBtn(_ sender: UIButton) {
        selectedTag = sender.tag
        updateBtnSelected()
        fetchRequestAPI(startPage: 0)
    }
    
    private func updateBtnSelected() {
        requestView.empty.isHidden = true
        requestView.requestTableView.isHidden = false
        requestData.removeAll()
        requestView.requestTableView.reloadData()
        
        for btn in [requestView.awaitingBtn, requestView.sentBtn, requestView.receivedBtn] {
            if btn.tag == selectedTag {
                btn.isSelected = true
            } else {
                btn.isSelected = false
            }
        }
    }
    
    private func fetchRequestAPI(startPage: Int) {
        Task {
            do {
                startLoading()
                self.isLoading = true
                
                var results: RequestResponse
                switch selectedTag {
                case 0:
                    status = "PENDING"
                    results = try await networkService.getPendingRequests(page: startPage)
                case 1:
                    status = "SENT"
                    results = try await networkService.getSentRequests(page: startPage)
                case 2:
                    status = "RECEIVED"
                    results = try await networkService.getReceivedRequests(page: startPage)
                default:
                    return
                }
                
    //                if (results.currentPage == 0) {
                    self.requestData.removeAll()
                    self.totalPage[selectedTag] = results.totalPage
    //                }
                self.requestData = results.applicationList
    //                self.currentPage[selectedTag] = results.currentPage
                
                DispatchQueue.main.async {
                    self.requestView.empty.isHidden = !self.requestData.isEmpty
                    self.requestView.requestTableView.reloadData()
                }
                
                self.stopLoading()
                self.isLoading = false
            } catch {
                self.stopLoading()
                self.isLoading = false
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func postSucceedAPI(_ applicationId: Int, _ cell: MyAccompanyCell) {
        Task {
            do {
                startLoading()
                
                let _ = try await networkService.postRequestSucceed(applicationId: applicationId)
                
                DispatchQueue.main.async {
                    cell.updateForRequest()
                }
                
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func postFailedAPI(_ applicationId: Int, _ cell: MyAccompanyCell) {
        Task {
            do {
                startLoading()
                
                let _ = try await networkService.postRequestFailed(applicationId: applicationId)
                
                DispatchQueue.main.async {
                    cell.updateForRequest()
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

extension RequestViewController: UITableViewDelegate, UITableViewDataSource, MyAccompanyCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyAccompanyCell.identifier, for: indexPath) as? MyAccompanyCell else {
            return UITableViewCell()
        }
        cell.configure(status: self.status, model: requestData[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func acceptBtnTapped(cell: MyAccompanyCell) {
        guard let indexPath = requestView.requestTableView.indexPath(for: cell) else { return }
        let selectedItem = requestData[indexPath.row]
        postSucceedAPI(selectedItem.applicationId, cell)
    }
    
    func rejectBtnTapped(cell: MyAccompanyCell) {
        guard let indexPath = requestView.requestTableView.indexPath(for: cell) else { return }
        let selectedItem = requestData[indexPath.row]
        postFailedAPI(selectedItem.applicationId, cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postId = requestData[indexPath.row].postId
        let detailVC = OtherPostDetailViewController()
        
        detailVC.postId = postId
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.frame.size.height

        if offsetY > contentHeight - tableViewHeight {
            guard !isLoading, currentPage[selectedTag] + 1 < totalPage[selectedTag] else { return }
            fetchRequestAPI(startPage: currentPage[selectedTag] + 1)
        }
    }
}
