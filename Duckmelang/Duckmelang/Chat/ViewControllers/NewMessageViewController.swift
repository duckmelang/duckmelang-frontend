//
//  NewMessageViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 2/21/25.
//

import UIKit
import SwiftyToaster

class NewMessageViewController: UIViewController, OtherMessageCellDelegate, ConfirmPopupViewController.ModalDelegate {
    
    func hideConfirmBtn() {
        messageView.topMessageView.confirmBtn.isHidden = true
    }
    
    private let socketManager = SocketManager()
    
    private var messageData: [MessageModel] = []
    
    private var memberId: Int?
    var postId: Int?
    var postDetail: MyPostDetailResponse?
    
    // MARK: - Properties
    
    private lazy var messageView: MessageView = {
        let view = MessageView()
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        self.view = messageView
        
        loadMemberId()
        setupNavigationBar()
        setupDelegate()
        setupAction()
        
        DispatchQueue.main.async {
            self.messageView.myPostDetail = self.postDetail
            self.scrollToLastItem()
        }
        connectWebSocket()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        socketManager.disConnect()
    }
    
    deinit {
        socketManager.disConnect()
    }
    
    // MARK: - Setup
    
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
    
    // MARK: - WebSocket
    
    private func connectWebSocket() {
        guard let memberId = self.memberId,
              let otherId = self.postDetail?.memberId else { return }
        
        let url = URL(string: "wss://13.125.217.231.nip.io/wss/chat")!

        socketManager.connect(to: url)
        
        // 연결 후 받은 메세지 받아오기
        socketManager.receiveMessage { result in
            switch result {
            case .success(let response):
                var newChatType: ChatType = .receive
                
                if (response.receiverId == memberId && response.senderId == otherId) {
                    newChatType = .receive
                } else if (response.receiverId == otherId && response.senderId == memberId) {
                    newChatType = .send
                } else {
                    return
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
    
    private func sendMessage(with text: String) {
        guard let memberId = self.memberId,
              let otherId = self.postDetail?.memberId,
              let postId = self.postId else { return }
        
        let newMessage = MessageRequest(
            senderId: memberId,
            receiverId: otherId,
            postId: postId,
            messageType: "TEXT",
            text: text
        )
        
        socketManager.sendMessage(messageRequest: newMessage) { [weak self] result in
            switch result {
            case .success:
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
    
    // MARK: - Actions
    
    // 뷰 생성 시에 멤버아이디 불러와서 저장하는 함수
    private func loadMemberId() {
        guard let memberIdString = KeychainManager.shared.load(key: "memberId"),
              let id = Int(memberIdString) else {
            Toaster.shared.makeToast("내 정보를 가져올 수 없습니다. 잠시 후 다시 시도해주세요.")
            return
        }

        self.memberId = id
    }
    
    @objc private func sendNewMessage() {
        guard let text = messageView.bottomMessageView.messageTextField.text else { return }
        if text.isEmpty { return }
        
        sendMessage(with: text)
    }
    
    private func reloadMessage() {
        self.messageView.messageCollectionView.reloadData()
        self.scrollToLastItem()
    }
    
    @objc private func openConfirmPopup() {
        let popupVC = ConfirmPopupViewController()
        popupVC.modalPresentationStyle = .overFullScreen
        
        popupVC.postId = self.postId
        popupVC.oppositeNickname = self.postDetail?.nickname
        popupVC.oppositeProfileImage = self.postDetail?.latestPublicMemberProfileImage
        
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

// MARK: - CollectionView 설정

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
