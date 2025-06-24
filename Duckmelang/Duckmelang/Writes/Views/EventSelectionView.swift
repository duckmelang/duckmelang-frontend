//
//  EventSelectionView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/20/25.
//

import UIKit
import SnapKit

class EventSelectionView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var eventCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.minimumInteritemSpacing = 8
        $0.minimumLineSpacing = 12
        $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
        $0.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width - 48, height: 50)
    }).then {
        $0.register(EventSelectionCell.self, forCellWithReuseIdentifier: EventSelectionCell.identifier)
        $0.register(EventSelectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EventSelectionHeader.identifier)
    }
    
    let completeButton = smallFilledCustomBtn(title: "완료")
    
    private func setupView() {
        addSubview(eventCollectionView)
        addSubview(completeButton)
        
        eventCollectionView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(64)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(completeButton.snp.top).inset(10)
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
}
