//
//  ChatViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/9/25.
//

import UIKit

class ChatViewController: UIViewController {
    var selectedTag: Int = 0

    let data1 = ChatModel.dummy()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = chatView
        self.tabBarController?.tabBar.isHidden = false
        
        setupNavigationBar()
        setupDelegate()
        setupAction()
        updateBtnSelected()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private lazy var chatView: ChatView = {
        let view = ChatView()
        return view
    }()
    
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
        chatView.doneBtn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
    }
    
    @objc func clickBtn(_ sender: UIButton) {
        selectedTag = sender.tag
        updateBtnSelected()
    }
    
    private func updateBtnSelected() {
        for btn in [chatView.allBtn, chatView.ongoingBtn, chatView.doneBtn] {
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
        return data1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatCell.identifier, for: indexPath) as? ChatCell else {
            return UITableViewCell()
        }
        
        cell.configure(model: data1[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messageVC = MessageViewController()
        navigationController?.pushViewController(messageVC, animated: true)
    }
}
