//
//  MessageViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/21/25.
//

import UIKit
import Moya

class MessageViewController: UIViewController, ConfirmPopupViewController.ModalDelegate, OtherMessageCellDelegate {
    private let provider = MoyaProvider<ChatAPI>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private let socketManager = SocketManager()
    
    var chat: ChatDTO?
    private var messageData: [MessageModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        self.view = messageView
        
        setupNavigationBar()
        setupDelegate()
        setupAction()
        
        DispatchQueue.main.async {
            self.scrollToLastItem()
        }
        
        getMessagesAPI()
        connectWebSocket()
        getDetailChatroomsAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
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
    
    private func getMessagesAPI() {
        provider.request(.getMessages(chatRoomId: chat?.chatRoomId ?? 0, size: 20)) { result in
            switch result {
            case .success(let response):
                self.messageData.removeAll()
                let response = try? response.map(ApiResponse<MessageResponse>.self)
                guard let results = response?.result?.chatMessageList else { return }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                dateFormatter.locale = Locale(identifier: "ko_KR")
                
                results.forEach { result in
                    let newChatType: ChatType = result.receiverId == 1 ? .receive : .send
                    var newDate = Date()
                    
                    if let date = dateFormatter.date(from: result.createdAt) {
                        print("Converted Date: \(date)")
                        newDate = date
                    } else {
                        print("Failed to convert date")
                    }
                    
                    let message = MessageModel(
                        text: result.text ?? "",
                        chatType: newChatType,
                        date: newDate
                    )
                    self.messageData.append(message)
                }
                
                print("메세지: \(self.messageData)")
                self.messageData = self.messageData.reversed()
                DispatchQueue.main.async {
                    self.reloadMessage()
                }
            case .failure(let error):
                print(error)
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
                let newChatType: ChatType = response.receiverId == 1 ? .receive : .send
                          
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
    
    private func getDetailChatroomsAPI() {
        provider.request(.getDetailChatroom(chatRoomId: self.chat?.chatRoomId ?? 0)) { result in
            switch result {
            case .success(let response):
                let response = try? response.map(ApiResponse<DetailChatroomResponse>.self)
                guard let result = response?.result else { return }
                print("채팅 상세 정보: \(result)")
                
                DispatchQueue.main.async {
                    self.messageView.detailChatroomResponse = result
                }
            case .failure(let error):
                print(error)
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
        let newMessage = MessageRequest(
            senderId: 1,
            receiverId: 2,
            postId: 2,
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
        sendNewMessage()
        return true
    }
}
