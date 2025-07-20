//
//  NoticeViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 2/1/25.
//

import UIKit
import SwiftyToaster

class NoticeViewController: UIViewController {
    let networkService = HomeService()
    
    private var notices: [NotificationModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = noticeView
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        
        setupActions()
        setupTableView()
        getNotificationsAPI()
    }
        
    private lazy var noticeView: NoticeView = {
        let view = NoticeView()
        return view
    }()
    
    private func setupActions() {
        noticeView.navibar.setLeftButtonAction(target: self, action: #selector(goBack))
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
    
    // MARK: - APIs
    
    private func getNotificationsAPI() {
        Task {
            do {
                startLoading()
                
                let result = try await networkService.getNotifications()
                self.notices = result.notificationList.reversed()
                
                DispatchQueue.main.async {
                    self.noticeView.noticeTableView.reloadData()
                }
                
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
                Toaster.shared.makeToast("알림을 가져오는 데 실패했습니다. \n 잠시 후 다시 시도해주세요.")
            }
        }
    }
    
    private func patchReadAPI(notificationId: Int, notificationType: String) {
        Task {
            do {
                startLoading()
                
                _ = try await networkService.patchNotifications(notificationId: notificationId)
                
                DispatchQueue.main.async {
                    self.getNotificationsAPI()
                    self.noticeView.noticeTableView.reloadData()
                }
                
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
                Toaster.shared.makeToast("알림 상태를 업데이트하지 못했습니다. \n 잠시 후 다시 시도해주세요.")
            }
        }
    }
    
    private func deleteNotificationsAPI(notificationId: Int) {
        Task {
            do {
                startLoading()
                
                _ = try await networkService.deleteNotifications(notificationId: notificationId)
                
                DispatchQueue.main.async {
                    self.noticeView.noticeTableView.reloadData()
                }
                
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
                Toaster.shared.makeToast("알림 상태를 삭제하지 못했습니다. \n 잠시 후 다시 시도해주세요.")
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
        let notification = notices[indexPath.row]
        patchReadAPI(notificationId: notification.id, notificationType: notification.type)
    }
    
    func tableView(_ tableView: UITableView,
                       commit editingStyle: UITableViewCell.EditingStyle,
                       forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNotificationsAPI(notificationId: notices[indexPath.row].id)
            notices.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
}
