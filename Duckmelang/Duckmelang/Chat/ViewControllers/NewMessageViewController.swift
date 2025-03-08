//
//  NewMessageViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 2/21/25.
//

import UIKit
import Moya

class NewMessageViewController: UIViewController, OtherMessageCellDelegate, ConfirmPopupViewController.ModalDelegate {
    func hideConfirmBtn() {
        messageView.topMessageView.confirmBtn.isHidden = true
    }
    
    private let provider = MoyaProvider<ChatAPI>(plugins: [TokenPlugin(), NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    private let socketManager = SocketManager()
    
    private var messageData: [MessageModel] = []
    
    var postId: Int?
    var postDetail: MyPostDetailResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        self.view = messageView
        
        setupNavigationBar()
        setupDelegate()
        setupAction()
        
        DispatchQueue.main.async {
            self.messageView.myPostDetail = self.postDetail
            self.scrollToLastItem()
        }
        connectWebSocket()
    }
    
    private lazy var messageView: MessageView = {
        let view = MessageView()
        return view
    }()
    
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
                    } else if (response.senderId == self.postDetail?.memberId) {
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
    
    @objc private func sendNewMessage() {
        if (messageView.bottomMessageView.messageTextField.text == "") {
            return
        }
        
        if let text = messageView.bottomMessageView.messageTextField.text {
            sendMessage(with: text)
        }
    }
    
    private func sendMessage(with text: String) {
        if let myId = KeychainManager.shared.load(key: "memberId"),
           let myId = Int(myId), let otherId = self.postDetail?.memberId, let postId = self.postId {
            let newMessage = MessageRequest(
                senderId: myId,
                receiverId: otherId,
                postId: postId,
                messageType: "TEXT",
                text: text
            )
            
            socketManager.sendMessage(messageRequest: newMessage) { [weak self] result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        let newMessageModel = MessageModel(text: text, chatType: .send, date: Date())
                        self?.messageData.append(newMessageModel)
                        self?.reloadMessage()
                        self?.messageView.bottomMessageView.messageTextField.text = "" // 입력창 초기화
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func reloadMessage() {
        self.messageView.messageCollectionView.reloadData()
        self.scrollToLastItem()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .white
        
        self.navigationItem.title = postDetail?.nickname
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
        messageView.bottomMessageView.sendBtn.addTarget(self, action: #selector(sendNewMessage), for: .touchUpInside)
    }
    
    @objc private func openConfirmPopup() {
        let popupVC = ConfirmPopupViewController()
        popupVC.modalPresentationStyle = .overFullScreen
        
        popupVC.postId = self.postId
        popupVC.oppositeNickname = postDetail?.nickname
        popupVC.oppositeProfileImage = postDetail?.latestPublicMemberProfileImage
        
        popupVC.delegate = self
        present(popupVC, animated: false)
    }
    
    private func scrollToLastItem() {
        let lastSection = messageView.messageCollectionView.numberOfSections - 1
        guard lastSection >= 0 else { return } // 섹션이 없을 경우 방지

        let lastItem = messageView.messageCollectionView.numberOfItems(inSection: lastSection) - 1
        guard lastItem >= 0 else { return } // 항목이 없을 경우 방지

        let lastIndexPath = IndexPath(item: lastItem, section: lastSection)
        messageView.messageCollectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: true)
    }
}

extension NewMessageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
            
            if let userImage = postDetail?.latestPublicMemberProfileImage {
                cell.configure(userImage: userImage, text: messageDate.text, date: dateFormatter.string(from: messageDate.date))
                cell.delegate = self
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    private func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func didTapUserImage(in cell: OtherMessageCell) {
        if let otherId = self.postDetail?.memberId {
            let otherProfileVC = OtherProfileViewController()
            otherProfileVC.oppositeId = otherId
            navigationController?.pushViewController(otherProfileVC, animated: true)
        }
    }
}

extension NewMessageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        sendNewMessage()
        return true
    }
}
