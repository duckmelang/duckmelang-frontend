//
//  MessageViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/21/25.
//

import UIKit

class MessageViewController: UIViewController, ConfirmPopupViewController.ModalDelegate, OtherMessageCellDelegate {
    private let networkService = ChatService()
    private let socketManager = SocketManager()
    
    private var messageData: [MessageModel] = []
    
    var chat: ChatDTO?
    var isLoading = false               // 중복 로딩 방지
    private var lastMessageId: String? // 페이지네이션을 위한 lastMessageId
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        
        self.view = messageView
        
        setupNavigationBar()
        setupDelegate()
        setupAction()
        
        DispatchQueue.main.async {
            self.scrollToLastItem()
        }
        
        getMessagesAPI(lastMessageId: nil)
        connectWebSocket()
        getDetailChatroomsAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        
        DispatchQueue.main.async {
            self.scrollToLastItem()
        }
        setupNavigationBar()
    }
    
    private lazy var messageView: MessageView = {
        let view = MessageView()
        return view
    }()
    
    func getMessagesAPI(lastMessageId: String?) {
        Task {
            do {
                startLoading()
                guard let chatRoomId = chat?.chatRoomId else { return }
                
                let response = try await networkService.getMessages(
                    chatRoomId: chatRoomId,
                    lastMessageId: lastMessageId,
                    size: 20
                )
                let results = response.chatMessageList
                self.lastMessageId = response.lastMessageId
                
                var newMessages: [MessageModel] = []
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                dateFormatter.locale = Locale(identifier: "ko_KR")
                
                results.forEach { result in
                    var newChatType: ChatType = .receive
                    if let myId = KeychainManager.shared.load(key: "memberId") {
                        if (result.receiverId == Int(myId)) {
                            newChatType = .receive
                        } else if (result.senderId == self.chat?.oppositeId) {
                            newChatType = .send
                        } else {
                            return
                        }
                    }
                    
                    var newDate = Date()
                    
                    if let date = dateFormatter.date(from: result.createdAt) {
                        newDate = date
                    } else {
                        print("Failed to convert date")
                    }
                    
                    let message = MessageModel(
                        text: result.text ?? "",
                        chatType: newChatType,
                        date: newDate
                    )
                    newMessages.append(message)
                }
                
                if lastMessageId == nil {
                    self.messageData = newMessages
                    self.messageData = self.messageData.reversed()
                    DispatchQueue.main.async {
                        self.reloadMessage()
                    }
                } else {
                    newMessages = newMessages.reversed()
                    self.messageData.insert(contentsOf: newMessages, at: 0)
                    DispatchQueue.main.async {
                        self.messageView.messageCollectionView.reloadData()
                        self.scrollToLastMessages()
                    }
                }
                stopLoading()
                isLoading = false
                print("메세지: \(self.messageData)")
            }
            catch {
                stopLoading()
                isLoading = false
                print(error.localizedDescription)
            }
        }
    }
    
    private func connectWebSocket() {
        let url = URL(string: "wss://13.125.217.231.nip.io/wss/chat")!

        socketManager.connect(to: url)
        
        // 연결 후 받은 메세지 받아오기
        socketManager.receiveMessage { result in
            switch result {
            case .success(let response):
                var newChatType: ChatType = .receive
                if let myId = KeychainManager.shared.load(key: "memberId") {
                    if (response.receiverId == Int(myId)) {
                        newChatType = .receive
                    } else if (response.senderId == self.chat?.oppositeId) {
                        newChatType = .send
                    } else {
                        return
                    }
                }
                
                let message = MessageModel(
                    text: response.text,
                    chatType: newChatType,
                    date: Date()
                )
                
                self.messageData.append(message)
                DispatchQueue.main.async {
                    self.reloadMessage()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getDetailChatroomsAPI() {
        guard let chatRoomId = self.chat?.chatRoomId else { return }
        
        Task {
            do {
                startLoading()
                let result = try await networkService.getDetailChatroom(chatRoomId: chatRoomId)

                stopLoading()
                DispatchQueue.main.async {
                    self.messageView.detailChatroomResponse = result
                }
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func sendNewMessage() {
        if (messageView.bottomMessageView.messageTextField.text == "") {
            return
        }
        
        if let text = messageView.bottomMessageView.messageTextField.text {
            sendMessage(with: text)
        }
    }
    
    private func sendMessage(with text: String) {
        guard let chat = chat else { return }
        guard let myId = Int(KeychainManager.shared.load(key: "memberId") ?? "변환실패") else { return }
        
        let newMessage = MessageRequest(
            senderId: myId,
            receiverId: chat.oppositeId,
            postId: chat.postId,
            messageType: "TEXT",
            text: text
        )
        
        let newMessageModel = MessageModel(text: text, chatType: .send, date: Date())
        
        socketManager.sendMessage(messageRequest: newMessage) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.messageData.append(newMessageModel)
                    self?.reloadMessage()
                    self?.messageView.bottomMessageView.messageTextField.text = "" // 입력창 초기화
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func reloadMessage() {
        self.messageView.messageCollectionView.reloadData()
        self.scrollToLastItem()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .white
        
        self.navigationItem.title = chat?.oppositeNickname
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.aritaSemiBoldFont(ofSize: 18)]
        
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(goBack))
        leftBarButton.tintColor = .grey600
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
    }
    
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupDelegate() {
        messageView.messageCollectionView.delegate = self
        messageView.messageCollectionView.dataSource = self
        messageView.bottomMessageView.messageTextField.delegate = self
    }
    
    private func setupAction() {
        messageView.topMessageView.confirmBtn.addTarget(self, action: #selector(openConfirmPopup), for: .touchUpInside)
        messageView.topMessageView.reviewBtn.addTarget(self, action: #selector(openReview), for: .touchUpInside)
        messageView.bottomMessageView.sendBtn.addTarget(self, action: #selector(sendNewMessage), for: .touchUpInside)
    }
    
    @objc private func openConfirmPopup() {
        let popupVC = ConfirmPopupViewController()
        popupVC.modalPresentationStyle = .overFullScreen
        
        popupVC.postId = chat?.postId
        popupVC.oppositeNickname = chat?.oppositeNickname
        popupVC.oppositeProfileImage = chat?.oppositeProfileImage
        
        popupVC.delegate = self
        present(popupVC, animated: false)
    }
    
    @objc private func openReview() {
        let afterReviewVC = AfterReviewViewController()
        afterReviewVC.oppositeId = chat?.oppositeId
        afterReviewVC.postId = chat?.postId
        navigationController?.pushViewController(afterReviewVC, animated: true)
    }
    
    private func scrollToLastItem() {
        let lastSection = messageView.messageCollectionView.numberOfSections - 1
        guard lastSection >= 0 else { return } // 섹션이 없을 경우 방지

        let lastItem = messageView.messageCollectionView.numberOfItems(inSection: lastSection) - 1
        guard lastItem >= 0 else { return } // 항목이 없을 경우 방지

        let lastIndexPath = IndexPath(item: lastItem, section: lastSection)
        messageView.messageCollectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: true)
    }
    
    private func scrollToLastMessages(count: Int = 20) {
        let totalItems = messageView.messageCollectionView.numberOfSections
        
        guard totalItems > 0 else { return }
        
        let targetIndex = max(totalItems - count, 0)
        let indexPath = IndexPath(item: 0, section: targetIndex)

        messageView.messageCollectionView.scrollToItem(at: indexPath, at: .top, animated: false)
    }
    
    func hideConfirmBtn() {
        messageView.topMessageView.confirmBtn.isHidden = true
    }
}

extension MessageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return messageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MessageHeaderCell.identifier,
            for: indexPath
        ) as! MessageHeaderCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"

        header.configure(date: dateFormatter.string(from: messageData[indexPath.section].date))
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 || !isSameDay(date1: messageData[section].date, date2: messageData[section - 1].date) {
            return CGSize(width: collectionView.bounds.width, height: 24)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let messageDate = messageData[indexPath.section]
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a hh:mm"
        
        if (messageDate.chatType == .send) {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyMessageCell.identifier,
                for: indexPath
            ) as? MyMessageCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(text: messageDate.text, date: dateFormatter.string(from: messageDate.date))
            return cell
        } else if (messageDate.chatType == .receive) {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: OtherMessageCell.identifier,
                for: indexPath
            ) as? OtherMessageCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(userImage: chat?.oppositeProfileImage ?? "", text: messageDate.text, date: dateFormatter.string(from: messageDate.date))
            cell.delegate = self
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.frame.size.height

        if offsetY > contentHeight - tableViewHeight {
            guard let lastMessageId = lastMessageId, !isLoading else { return }
            getMessagesAPI(lastMessageId: lastMessageId)
        }
    }

    private func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func didTapUserImage(in cell: OtherMessageCell) {
        let otherProfileVC = OtherProfileViewController()
        otherProfileVC.oppositeId = chat?.oppositeId
        navigationController?.pushViewController(otherProfileVC, animated: true)
    }
}

extension MessageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        sendNewMessage()
        return true
    }
}
