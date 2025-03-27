//
//  EventSelectionViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/20/25.
//

import UIKit

protocol EventSelectionViewControllerDelegate: AnyObject {
    func didSelectEvent(_ event: EventDTO)
}

class EventSelectionViewController: UIViewController {
    weak var delegate: EventSelectionViewControllerDelegate?
    
    let networkService = HomeService()
    
    var eventKinds: [String] = ["공연", "행사"]
    var concertEvents: [EventDTO] = []
    var festivalEvents: [EventDTO] = []
    var selectedEvent: EventDTO?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = eventSelectionView
        setupDelegates()
        getEventsAPI()
    }
    
    private lazy var eventSelectionView: EventSelectionView = {
        let view = EventSelectionView()
        view.completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        return view
    }()
    
    private func setupDelegates() {
        eventSelectionView.eventCollectionView.delegate = self
        eventSelectionView.eventCollectionView.dataSource = self
    }
    
    // 아이돌 목록 불러오기
    private func getEventsAPI() {
        Task {
            do {
                startLoading()
                
                let result = try await networkService.getEvents()
                self.concertEvents = result.eventCategoryList.filter { $0.eventKind == "공연" }
                self.festivalEvents = result.eventCategoryList.filter { $0.eventKind == "행사" }
                
                DispatchQueue.main.async {
                    self.eventSelectionView.eventCollectionView.reloadData()
                }
                
                stopLoading()
            }
            catch {
                stopLoading()
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func didTapCompleteButton() {
        if let selectedEvent = selectedEvent {
            delegate?.didSelectEvent(selectedEvent)
            dismiss(animated: true)
        }
    }
}

extension EventSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

        if event.eventId == selectedEvent?.eventId {
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
        if section == 0 { // 공연
            selectedEvent = concertEvents[indexPath.row]
        } else if section == 1 { // 행사
            selectedEvent = festivalEvents[indexPath.row]
        }
    }
}
