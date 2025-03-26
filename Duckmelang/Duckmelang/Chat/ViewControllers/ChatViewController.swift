//
//  ChatViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/9/25.
//

import UIKit

class ChatViewController: UIViewController {
    private let networkService = ChatService()
    
    var chatData: [ChatDTO] = []
    
    var selectedTag: Int = 0
    
    var isLoading = false            // 중복 로딩 방지
    var totalPage = [0, 0, 0, 0]     // 마지막 페이지인지 여부
    var currentPage = [0, 0, 0, 0]   // 현재 페이지 번호
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = chatView
        self.tabBarController?.tabBar.isHidden = false
        
        setupNavigationBar()
        setupDelegate()
        setupAction()
        updateBtnSelected()
        fetchChatrooms(startPage: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private lazy var chatView: ChatView = {
        let view = ChatView()
        return view
    }()
    
    private func fetchChatrooms(startPage: Int) {
        Task {
            do {
                startLoading()
                self.isLoading = true
                
                var results: ChatResponse
                switch selectedTag {
                case 0:
                    results = try await networkService.getChatrooms(page: startPage)
                case 1:
                    results = try await networkService.getOngoingChatrooms(page: startPage)
                case 2:
                    results = try await networkService.getConfirmedChatrooms(page: startPage)
                case 3:
                    results = try await networkService.getTerminatedChatrooms(page: startPage)
                default:
                    return
                }
                
    //                if (results.currentPage == 0) {
                    self.chatData.removeAll()
    //                    self.totalPage[selectedTag] = results.totalPage
    //                }
                self.chatData = results.chatRoomList
    //                self.currentPage[selectedTag] = results.currentPage
                
                DispatchQueue.main.async {
                    self.chatView.empty.isHidden = !self.chatData.isEmpty
                    self.chatView.chatTableView.reloadData()
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
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .white
        
        self.navigationItem.title = "채팅"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.aritaSemiBoldFont(ofSize: 18)]
        
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "bell"), style: .plain, target: self, action: #selector(clickBell))
        rightBarButton.tintColor = .grey500
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    @objc private func clickBell() {
        print("알림 버튼 클릭")
        let noticeVC = NoticeViewController()
        noticeVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(noticeVC, animated: true)
    }
    
    private func setupDelegate() {
        chatView.chatTableView.dataSource = self
        chatView.chatTableView.delegate = self
    }
    
    private func setupAction() {
        chatView.allBtn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        chatView.ongoingBtn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        chatView.confirmBtn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        chatView.doneBtn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
    }
    
    @objc func clickBtn(_ sender: UIButton) {
        selectedTag = sender.tag
        updateBtnSelected()
        fetchChatrooms(startPage: 0)
    }
    
    private func updateBtnSelected() {
        chatView.empty.isHidden = true
        chatView.chatTableView.isHidden = false
        chatData.removeAll()
        chatView.chatTableView.reloadData()
        
        for btn in [chatView.allBtn, chatView.ongoingBtn, chatView.confirmBtn, chatView.doneBtn] {
            if btn.tag == selectedTag {
                btn.isSelected = true
            } else {
                btn.isSelected = false
            }
        }
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.identifier, for: indexPath) as? ChatCell else {
            return UITableViewCell()
        }
        
        cell.configure(model: chatData[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = chatData[indexPath.row]
        
        let messageVC = MessageViewController()
        messageVC.chat = chat
        navigationController?.pushViewController(messageVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.frame.size.height

        if offsetY > contentHeight - tableViewHeight {
            guard !isLoading, currentPage[selectedTag] + 1 < totalPage[selectedTag] else { return }
            fetchChatrooms(startPage: currentPage[selectedTag] + 1)
        }
    }
}
