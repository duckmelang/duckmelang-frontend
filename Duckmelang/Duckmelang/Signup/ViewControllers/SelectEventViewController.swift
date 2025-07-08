//
//  SelectEventViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 5/21/25.
//

import UIKit

class SelectEventViewController: UIViewController {
    let networkService = SignupService()
    
    private var events: [EventCategoryList] = []
    private var selectedEventIds: [Int] = [] {
        didSet {
            self.selectEventView.nextBtn.setEnabled(!selectedEventIds.isEmpty)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = selectEventView
        setupDelegates()
        getEventList()
        setupNavigationBar()
    }
    
    private lazy var selectEventView: SelectEventView = {
        let view = SelectEventView()
        view.nextBtn.addTarget(self, action: #selector(nextBtn), for: .touchUpInside)
        return view
    }()
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.backgroundColor = .white
        
        self.navigationItem.title = "회원가입"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.aritaSemiBoldFont(
            ofSize: 18
        )]
        
        let leftBarButton = UIBarButtonItem(
            image: UIImage(named: "back"),
            style: .plain,
            target: self,
            action: #selector(openBackPopup)
        )
        leftBarButton.tintColor = .grey600
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
    }
    
    @objc private func openBackPopup() {
        let popupVC = ProfileCancelPopupViewController()
        popupVC.modalPresentationStyle = .overFullScreen
        present(popupVC, animated: false)
    }
    
    private func setupDelegates() {
        selectEventView.eventCollectionView.delegate = self
        selectEventView.eventCollectionView.dataSource = self
    }
    
    private func getEventList() {
        Task {
            do {
                startLoading()
                
                let result = try await networkService.getAllEvents()
                self.events = result.eventCategoryList
                
                DispatchQueue.main.async {
                    self.selectEventView.eventCollectionView.reloadData()
                }
                
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
    
    // 다음 버튼 눌렀을 때
    @objc func nextBtn() {
        // MARK: TEST
//        navigateToFilterKeywordsView()
        postSelectedEvents()
    }
    
    private func postSelectedEvents() {
        if selectedEventIds.isEmpty {
            print("❌ 선택된 이벤트 없음. 요청을 보내지 않음.")
            return
        }
        
        print("🟢 선택된 이벤트 ID: \(selectedEventIds) → 서버로 전송")

        let request = SelectFavoriteEventRequest(eventCategoryIds: selectedEventIds)
        postMemberInterestEventAPI(eventNums: request)
    }
    
    private func postMemberInterestEventAPI(eventNums: SelectFavoriteEventRequest) {
        guard let memberIdString = KeychainManager.shared.load(key: "memberId"),
              let memberId = Int(memberIdString) else { return }
        
        Task {
            do {
                startLoading()
                
                _ = try await networkService.postMemberInterestEvent(
                    memberId: memberId,
                    eventNums: eventNums
                )
                
                DispatchQueue.main.async {
                    self.navigateToFilterKeywordsView()
                }
                
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
    
    private func navigateToFilterKeywordsView() {
        let filterVC = FilterKeywordsViewController()
        filterVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(filterVC, animated: true)
    }
}

extension SelectEventViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventSelectionCell.identifier, for: indexPath) as? EventSelectionCell else {
            return UICollectionViewCell()
        }
        
        let event = events[indexPath.item]
        cell.configure(event: event)
        cell.isSelected = selectedEventIds.contains(event.eventID)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let eventID = events[indexPath.item].eventID
        
        if selectedEventIds.contains(where: { $0 == eventID }) {
            selectedEventIds.removeAll(where: { $0 == eventID })
        } else {
            selectedEventIds.append(eventID)
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? EventSelectionCell {
            cell.isSelected = selectedEventIds.contains(eventID)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let eventID = events[indexPath.item].eventID
        
        if selectedEventIds.contains(where: { $0 == eventID }) {
            selectedEventIds.removeAll(where: { $0 == eventID })
        } else {
            selectedEventIds.append(eventID)
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? EventSelectionCell {
            cell.isSelected = selectedEventIds.contains(eventID)
        }
    }
}
