//
//  ChatViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/9/25.
//

import UIKit
import Moya

class ChatViewController: UIViewController {
    private let provider = MoyaProvider<ChatAPI>(plugins: [TokenPlugin(), NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    var chatData: [ChatDTO] = []
    
    var selectedTag: Int = 0
    
    var isLoading = false   // 중복 로딩 방지
    var isLastPage = [false, false, false, false]  // 마지막 페이지인지 여부
    var currentPage = [0, 0, 0, 0]    // 현재 페이지 번호
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = chatView
        self.tabBarController?.tabBar.isHidden = false
        
        setupNavigationBar()
        setupDelegate()
        setupAction()
        updateBtnSelected()
        fetchChatrooms(api: .getChatrooms(page: 0))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private lazy var chatView: ChatView = {
        let view = ChatView()
        return view
    }()
    
    private func fetchChatrooms(api: ChatAPI) {
        guard !isLoading && !isLastPage[selectedTag] else { return } // 중복 호출 & 마지막 페이지 방지
        isLoading = true
        
        provider.request(api) { result in
            switch result {
            case .success(let response):
                DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                    let response = try? response.map(ApiResponse<ChatResponse>.self)
                    guard let result = response?.result?.chatRoomList else { return }
                    guard let isLast = response?.result?.isLast else { return }
                    
                    DispatchQueue.main.async {
                        if self.currentPage[self.selectedTag] == 0 {
                            self.chatData = result // 첫 페이지면 초기화
                        } else {
                            self.chatData.append(contentsOf: result) // 페이지네이션: 데이터 추가
                        }

                        print("요청 목록: \(self.chatData)")
                        
                        if (self.isLastPage[self.selectedTag]) {
                            self.chatView.chatTableView.tableFooterView = nil
                        }

                        self.chatView.empty.isHidden = !self.chatData.isEmpty
                        self.isLastPage[self.selectedTag] = isLast // 마지막 페이지 여부 업데이트
                        self.isLoading = false
                        self.chatView.loadingIndicator.stopLoading()
                        self.chatView.chatTableView.reloadData()
                    }
                }
            case .failure(let error):
                print(error)
                self.isLoading = false
                self.chatView.loadingIndicator.stopLoading()
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
        updateData()
    }
    
    private func updateBtnSelected() {
        chatView.empty.isHidden = true
        chatView.chatTableView.isHidden = false
        chatData.removeAll()
        chatView.chatTableView.reloadData()
        
        chatView.loadingIndicator.startLoading()
        
        for btn in [chatView.allBtn, chatView.ongoingBtn, chatView.confirmBtn, chatView.doneBtn] {
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
            fetchChatrooms(api: .getChatrooms(page: currentPage[selectedTag]))
        case 1:
            fetchChatrooms(api: .getOngoingChatrooms(page: currentPage[selectedTag]))
        case 2:
            fetchChatrooms(api: .getConfirmedChatrooms(page: currentPage[selectedTag]))
        case 3:
            fetchChatrooms(api: .getTerminatedChatrooms(page: currentPage[selectedTag]))
        default:
            return
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
                fetchChatrooms(api: .getChatrooms(page: currentPage[selectedTag]))
            case 1:
                fetchChatrooms(api: .getOngoingChatrooms(page: currentPage[selectedTag]))
            case 2:
                fetchChatrooms(api: .getConfirmedChatrooms(page: currentPage[selectedTag]))
            case 3:
                fetchChatrooms(api: .getTerminatedChatrooms(page: currentPage[selectedTag]))
            default:
                return
            }
        }
    }
}
