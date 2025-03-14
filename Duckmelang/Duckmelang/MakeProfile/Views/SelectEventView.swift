//
//  SelectEventView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/28/25.
//

import UIKit
import Then
import SnapKit

class SelectEventView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    weak var delegate: SelectEventViewDelegate?
    
    private let titleLabel = UILabel().then {
        $0.text = "자주 가는 행사를 알려주세요!"
        $0.font = UIFont.aritaBoldFont(ofSize: 20)
        $0.textColor = .grey800
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "언제든 변경할 수 있어요"
        $0.font = UIFont.ptdRegularFont(ofSize: 13)
        $0.textColor = .grey600
    }
    
    private var eventsView: [EventCategoryList] = []
    public var selectedEvents: Set<Int> = [] {
        didSet {
            delegate?.selectedEventsDidChange(selectedEvents) // ✅ 값이 변경될 때 VC로 전달
        }
    }
    
    private lazy var eventCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 80, height: 40)
        layout.minimumInteritemSpacing = 14  // 좌우 간격
        layout.minimumLineSpacing = 20  // 위아래 간격

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: EventCollectionViewCell.identifier)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupView()
        
        eventCollectionView.allowsSelection = true
        eventCollectionView.isUserInteractionEnabled = true
        
        eventCollectionView.delegate = self
        eventCollectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [
            titleLabel,
            subtitleLabel,
            eventCollectionView
        ].forEach {
            addSubview($0)
        }
            
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview()
        }
        
        eventCollectionView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // 서버에서 받은 데이터 업데이트
    func updateWithEvents(events: [EventCategoryList]) {
        self.eventsView = events
        eventCollectionView.reloadData()
    }

    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventsView.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCollectionViewCell.identifier, for: indexPath) as! EventCollectionViewCell
        
        let event = eventsView[indexPath.row]
        cell.configureEventButton(title: event.eventName, isSelected: selectedEvents.contains(event.eventID))
        
        return cell
    }

    // 선택 시 토글 및 로그 추가
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = eventsView[indexPath.row]

        if selectedEvents.contains(event.eventID) {
            selectedEvents.remove(event.eventID)
            print("🛑 이벤트 선택 해제: \(event.eventName) (ID: \(event.eventID))")
        } else {
            selectedEvents.insert(event.eventID)
            print("✅ 이벤트 선택됨: \(event.eventName) (ID: \(event.eventID))")
        }

        print("📌 현재 선택된 이벤트 ID 목록: \(Array(selectedEvents))")
        
        delegate?.selectedEventsDidChange(selectedEvents)

        collectionView.reloadItems(at: [indexPath])
        
        collectionView.reloadData()
    }
}

protocol SelectEventViewDelegate: AnyObject {
    func selectedEventsDidChange(_ selectedEvents: Set<Int>)
}
