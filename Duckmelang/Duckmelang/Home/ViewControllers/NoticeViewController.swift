//
//  NoticeViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 2/1/25.
//

import UIKit
import Moya

class NoticeViewController: UIViewController {
    private let provider = MoyaProvider<NotificationAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private var notices: [NotificationModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = noticeView
        self.navigationController?.isNavigationBarHidden = false
        setupNavigationBar()
        setupTableView()
        getNotificationsAPI()
    }
        
    private lazy var noticeView: NoticeView = {
        let view = NoticeView()
        return view
    }()
    
    private func setupNavigationBar() {
        self.navigationItem.title = "알림"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.aritaSemiBoldFont(ofSize: 18)]
        
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(goBack))
        leftBarButton.tintColor = .grey600
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
        }
        
    @objc private func goBack() {
        if navigationController?.viewControllers.count == 1 {
            // 네비게이션 스택에 다른 화면이 없으면 baseVC를 새로 생성
            let baseVC = BaseViewController()
            navigationController?.navigationBar.isHidden = true
            navigationController?.setViewControllers([baseVC], animated: true)
        } else {
            // 기존 네비게이션 스택에서 뒤로가기
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupTableView() {
        noticeView.noticeTableView.delegate = self
        noticeView.noticeTableView.dataSource = self
    }
    
    private func getNotificationsAPI() {
        provider.request(.getNotifications) { result in
            switch result {
            case .success(let response):
                let response = try? response.map(ApiResponse<NotificationResponse>.self)
                guard let result = response?.result?.notificationList else { return }
                self.notices = result
                self.notices = self.notices.reversed()
                print("알림 목록: \(self.notices)")
                
                DispatchQueue.main.async {
                    self.noticeView.noticeTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func patchReadAPI(_ notificationId: Int) {
        provider.request(.patchNotifications(notificationId: notificationId)) { result in
            switch result {
            case .success(let response):
                print("알림 읽음: \(response)")
                
                DispatchQueue.main.async {
                    self.getNotificationsAPI()
                    self.noticeView.noticeTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UITableView Delegate & DataSource
extension NoticeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoticeCell.identifier, for: indexPath) as? NoticeCell else {
            return UITableViewCell()
        }
        let notice = notices[indexPath.row]
        cell.configure(with: notice)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notificationId = notices[indexPath.row].id
        patchReadAPI(notificationId)
    }
}
