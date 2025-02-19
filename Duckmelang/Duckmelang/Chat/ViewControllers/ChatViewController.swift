//
//  ChatViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/9/25.
//

import UIKit
import Moya

class ChatViewController: UIViewController {
    private let provider = MoyaProvider<ChatAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    var selectedTag: Int = 0

    let data1 = ChatModel.dummy()
    var chatData: [ChatDTO] = []
    
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
        provider.request(api) { result in
            switch result {
            case .success(let response):
                self.chatData.removeAll()
                let response = try? response.map(ApiResponse<ChatResponse>.self)
                guard let result = response?.result?.chatRoomList else { return }
                self.chatData = result
                print("채팅 목록: \(self.chatData)")
                
                DispatchQueue.main.async {
                    self.chatView.empty.isHidden = !result.isEmpty
                    self.chatView.chatTableView.reloadData()
                }
            case .failure(let error):
                print(error)
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
        
        switch selectedTag {
        case 0:
            fetchChatrooms(api: .getChatrooms(page: 0))
        case 1:
            fetchChatrooms(api: .getOngoingChatrooms(page: 0))
        case 2:
            fetchChatrooms(api: .getConfirmedChatrooms(page: 0))
        case 3:
            fetchChatrooms(api: .getTerminatedChatrooms(page: 0))
        default:
            return
        }
        
        updateBtnSelected()
    }
    
    private func updateBtnSelected() {
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
        messageVC.chatRoomId = chat.chatRoomId
        messageVC.oppositeNickname = chat.oppositeNickname
        navigationController?.pushViewController(messageVC, animated: true)
    }
}
