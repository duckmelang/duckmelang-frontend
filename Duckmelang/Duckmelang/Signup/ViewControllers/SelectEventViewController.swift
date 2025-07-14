//
//  SelectEventViewController.swift
//  Duckmelang
//
//  Created by 주민영 on 5/21/25.
//

import UIKit

class SelectEventViewController: UIViewController {
    let networkService = SignupService()
    
    var eventKinds: [String] = ["공연", "행사"]
    var concertEvents: [EventDTO] = []
    var festivalEvents: [EventDTO] = []
    
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
                self.concertEvents = result.eventCategoryList.filter { $0.eventKind == "공연" }
                self.festivalEvents = result.eventCategoryList.filter { $0.eventKind == "행사" }
                
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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return eventKinds.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let kind = eventKinds[section]
        if kind == eventKinds[0] {
            return concertEvents.count
        } else if kind == eventKinds[1] {
            return festivalEvents.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventSelectionCell.identifier, for: indexPath) as! EventSelectionCell
        let kind = eventKinds[indexPath.section]
        let event: EventDTO

        if kind == eventKinds[0] { // 공연
            event = concertEvents[indexPath.row]
        } else { // 행사
            event = festivalEvents[indexPath.row]
        }

        cell.configure(event: event)
        
        if selectedEventIds.contains(event.eventId) {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        } else {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EventSelectionHeader.identifier, for: indexPath) as! EventSelectionHeader
        headerView.configure(text: eventKinds[indexPath.section])
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let eventId: Int

        if section == 0 { // 공연
            eventId = concertEvents[indexPath.row].eventId
        } else { // 행사
            eventId = festivalEvents[indexPath.row].eventId
        }

        if let index = selectedEventIds.firstIndex(of: eventId) {
            // 이미 선택된 상태면 → 선택 해제
            selectedEventIds.remove(at: index)
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            // 선택 안된 상태면 → 선택
            selectedEventIds.append(eventId)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let eventId: Int

        if section == 0 { // 공연
            eventId = concertEvents[indexPath.row].eventId
        } else { // 행사
            eventId = festivalEvents[indexPath.row].eventId
        }

        if let index = selectedEventIds.firstIndex(of: eventId) {
            // 이미 선택된 상태면 → 선택 해제
            selectedEventIds.remove(at: index)
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            // 선택 안된 상태면 → 선택
            selectedEventIds.append(eventId)
        }
    }

}
