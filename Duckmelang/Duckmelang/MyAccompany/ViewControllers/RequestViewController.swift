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
    
//    private var requestData = MyAccompanyModel.dummy()
    private var requestData: [RequestDTO] = []
    
    var selectedTag: Int = 0
    var status: String = ""
    
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
        for btn in [requestView.awaitingBtn, requestView.sentBtn, requestView.receivedBtn] {
            if btn.tag == selectedTag {
                btn.isSelected = true
            } else {
                btn.isSelected = false
            }
        }
    }

    private func updateData() {
        switch selectedTag {
        case 0:
            status = "PENDING"
            getPendingAPI()
        case 1:
            status = "SENT"
            getSentAPI()
        case 2:
            status = "RECEIVED"
            getReceivedAPI()
        default:
            break
        }
    }
    
    private func getPendingAPI() {
        provider.request(.getPendingRequests(memberId: 1, page: 0)) { result in
            switch result {
            case .success(let response):
                self.requestData.removeAll()
                let response = try? response.map(ApiResponse<RequestResponse>.self)
                guard let result = response?.result?.requestApplicationList else { return }
                self.requestData = result
                print("대기 중: \(self.requestData)")
                DispatchQueue.main.async {
                    self.requestView.requestTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    private func getSentAPI() {
        provider.request(.getSentRequests(memberId: 1, page: 0)) { result in
            switch result {
            case .success(let response):
                self.requestData.removeAll()
                let response = try? response.map(ApiResponse<RequestResponse>.self)
                guard let result = response?.result?.requestApplicationList else { return }
                self.requestData = result
                print("보낸 요청: \(self.requestData)")
                DispatchQueue.main.async {
                    self.requestView.requestTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    private func getReceivedAPI() {
        provider.request(.getReceivedRequests(memberId: 1, page: 0)) { result in
            switch result {
            case .success(let response):
                self.requestData.removeAll()
                let response = try? response.map(ApiResponse<RequestResponse>.self)
                guard let result = response?.result?.requestApplicationList else { return }
                self.requestData = result
                print("받은 요청: \(self.requestData)")
                DispatchQueue.main.async {
                    self.requestView.requestTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func postSucceedAPI(_ applicationId: Int, _ cell: MyAccompanyCell) {
        provider.request(.postRequestSucceed(applicationId: applicationId, memberId: 1)) { result in
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
        provider.request(.postRequestFailed(applicationId: applicationId, memberId: 1)) { result in
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
}
