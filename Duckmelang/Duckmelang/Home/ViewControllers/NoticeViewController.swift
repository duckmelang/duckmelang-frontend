//
//  NoticeViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 2/1/25.
//

import UIKit

class NoticeViewController: UIViewController {
    
    private var notices: [NoticeModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = noticeView
        self.navigationController?.isNavigationBarHidden = false
        setupNavigationBar()
        setupTableView()
        loadNotices()
    }
        
    private lazy var noticeView: NoticeView = {
        let view = NoticeView()
        return view
    }()
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .white
        
        self.navigationItem.title = "알림"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.aritaSemiBoldFont(ofSize: 18)]
        
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(goBack))
        leftBarButton.tintColor = .grey600
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
        }
        
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
        }
    
    private func setupTableView() {
            noticeView.noticeTableView.delegate = self
            noticeView.noticeTableView.dataSource = self
        }

        private func loadNotices() {
            let scrapped = NoticeModel.dummyScrapped()
            let accompanyAccept = NoticeModel.dummyAccompanyAccept()
            let accompanyRequest = NoticeModel.dummyAccompanyRequest()

            notices = scrapped + accompanyAccept + accompanyRequest
            noticeView.noticeTableView.reloadData()
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
        cell.configure(with: notice, isNew: indexPath.row < 2) // 상위 2개는 새로운 알림으로 처리
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
