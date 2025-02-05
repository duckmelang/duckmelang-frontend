//
//  MessageViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 1/21/25.
//

import UIKit

class MessageViewController: UIViewController, ConfirmPopupViewController.ModalDelegate {
    var data = MessageModel.dummy()
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        DispatchQueue.main.async {
            self.scrollToLastItem()
        }
    }
    
    private lazy var messageView: MessageView = {
        let view = MessageView()
        return view
    }()
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .white
        
        self.navigationItem.title = "유저네임"
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
        messageView.bottomMessageView.sendBtn.addTarget(self, action: #selector(appendNewMessage), for: .touchUpInside)
    }
    
    @objc private func openConfirmPopup() {
        let popupVC = ConfirmPopupViewController()
        popupVC.modalPresentationStyle = .overFullScreen
        popupVC.delegate = self
        present(popupVC, animated: false)
    }
    
    @objc private func openReview() {
        let afterReviewVC = AfterReviewViewController()
        navigationController?.pushViewController(afterReviewVC, animated: true)
    }
    
    @objc private func appendNewMessage() {
        if (messageView.bottomMessageView.messageTextField.text == "") {
            return
        }
        
        let newMessage = MessageModel(text: messageView.bottomMessageView.messageTextField.text ?? "", chatType: .send, date: Date())
        data.append(newMessage)
        messageView.messageCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.scrollToLastItem()
        }
        
        messageView.bottomMessageView.messageTextField.text = "" // 입력창 초기화
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

extension MessageViewController: UICollectionViewDelegate, UICollectionViewDataSource, OtherMessageCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: 메세지의 날짜가 달라지면 상단에 날짜가 표시되게
        let messageDate = data[indexPath.item]
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        if indexPath.item == 0 || !isSameDay(date1: data[indexPath.item].date, date2: data[indexPath.item - 1].date) {
            dateFormatter.dateFormat = "MM월 dd일 a hh:mm"
        } else {
            dateFormatter.dateFormat = "a hh:mm"
        }
        
        if (messageDate.chatType == .send) {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyMessageCell.identifier,
                for: indexPath
            ) as? MyMessageCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(text: messageDate.text, date: dateFormatter.string(from: data[indexPath.row].date))
            return cell
        } else if (messageDate.chatType == .receive) {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: OtherMessageCell.identifier,
                for: indexPath
            ) as? OtherMessageCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(userImage: UIImage(), text: messageDate.text, date: dateFormatter.string(from: messageDate.date))
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
        navigationController?.pushViewController(otherProfileVC, animated: true)
    }
}

extension MessageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        appendNewMessage()
        return true
    }
}
