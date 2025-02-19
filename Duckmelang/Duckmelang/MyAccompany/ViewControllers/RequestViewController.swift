//
//  RequestViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/31/25.
//

import UIKit
import Moya

class RequestViewController: UIViewController {
    private let provider = MoyaProvider<MyAccompanyAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    private var requestData: [RequestDTO] = []
    
    var selectedTag: Int = 0
    var status: String = ""
    
    var isLoading = false   // 중복 로딩 방지
    var isLastPage = [false, false, false]  // 마지막 페이지인지 여부
    var currentPage = [0, 0, 0]    // 현재 페이지 번호
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = requestView
        setupDelegate()
        setupAction()
        updateBtnSelected()
        updateData()
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
        updateData()
    }
    
    private func updateBtnSelected() {
        requestView.empty.isHidden = true
        requestView.requestTableView.isHidden = false
        requestData.removeAll()
        requestView.requestTableView.reloadData()
        
        requestView.loadingIndicator.startLoading()
        
        for btn in [requestView.awaitingBtn, requestView.sentBtn, requestView.receivedBtn] {
            if btn.tag == selectedTag {
                btn.isSelected = true
            } else {
                btn.isSelected = false
            }
        }
    }

    private func updateData() {
        currentPage[selectedTag] = 0
        isLastPage[selectedTag] = false
        
        switch selectedTag {
        case 0:
            status = "PENDING"
            fetchRequestAPI(api: .getPendingRequests(page: currentPage[selectedTag]))
        case 1:
            status = "SENT"
            fetchRequestAPI(api: .getSentRequests(page: currentPage[selectedTag]))
        case 2:
            status = "RECEIVED"
            fetchRequestAPI(api: .getReceivedRequests(page: currentPage[selectedTag]))
        default:
            break
        }
    }
    
    private func fetchRequestAPI(api: MyAccompanyAPI) {
        guard !isLoading && !isLastPage[selectedTag] else { return } // 중복 호출 & 마지막 페이지 방지
        isLoading = true
        
        provider.request(api) { result in
            switch result {
            case .success(let response):
                DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                    let response = try? response.map(ApiResponse<RequestResponse>.self)
                    guard let result = response?.result?.applicationList else { return }
                    guard let isLast = response?.result?.isLast else { return }
                    
                    DispatchQueue.main.async {
                        if self.currentPage[self.selectedTag] == 0 {
                            self.requestData = result // 첫 페이지면 초기화
                        } else {
                            self.requestData.append(contentsOf: result) // 페이지네이션: 데이터 추가
                        }

                        print("요청 목록: \(self.requestData)")
                        
                        if (self.isLastPage[self.selectedTag]) {
                            self.requestView.requestTableView.tableFooterView = nil
                        }

                        self.requestView.empty.isHidden = !self.requestData.isEmpty
                        self.isLastPage[self.selectedTag] = isLast // 마지막 페이지 여부 업데이트
                        self.isLoading = false
                        self.requestView.loadingIndicator.stopLoading()
                        self.requestView.requestTableView.reloadData()
                    }
                }
            case .failure(let error):
                print(error)
                self.isLoading = false
                self.requestView.loadingIndicator.stopLoading()
            }
        }
    }
    
    private func postSucceedAPI(_ applicationId: Int, _ cell: MyAccompanyCell) {
        provider.request(.postRequestSucceed(applicationId: applicationId)) { result in
            switch result {
            case .success(let response):
                print("요청 수락 성공: \(response)")
                
                DispatchQueue.main.async {
                    cell.updateForRequest()
                    self.updateData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    private func postFailedAPI(_ applicationId: Int, _ cell: MyAccompanyCell) {
        provider.request(.postRequestFailed(applicationId: applicationId)) { result in
            switch result {
            case .success(let response):
                print("요청 거절 성공: \(response)")
                
                DispatchQueue.main.async {
                    cell.updateForRequest()
                    self.updateData()
                }
            case .failure(let error):
                print(error)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (isLastPage[selectedTag]) {
            return
        }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.frame.size.height

        if offsetY > contentHeight - tableViewHeight * 2 {
            self.currentPage[self.selectedTag] += 1  // 페이지 증가
            switch selectedTag {
            case 0:
                status = "PENDING"
                fetchRequestAPI(api: .getPendingRequests(page: currentPage[0]))
            case 1:
                status = "SENT"
                fetchRequestAPI(api: .getSentRequests(page: currentPage[1]))
            case 2:
                status = "RECEIVED"
                fetchRequestAPI(api: .getReceivedRequests(page: currentPage[2]))
            default:
                break
            }
        }
    }
}
