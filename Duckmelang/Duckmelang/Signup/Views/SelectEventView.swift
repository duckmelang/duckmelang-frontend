//
//  SelectEventView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/28/25.
//

import UIKit
import Then
import SnapKit

class SelectEventView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let progressBar = ProgressBarView(currentStep: 2)
    
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
    
    public lazy var eventCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.minimumInteritemSpacing = 14
        $0.minimumLineSpacing = 20
        $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 34, right: 0)
        $0.headerReferenceSize = CGSize(width: 40, height: 50)
    }).then {
        $0.register(EventSelectionCell.self, forCellWithReuseIdentifier: EventSelectionCell.identifier)
        $0.register(EventSelectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EventSelectionHeader.identifier)
        $0.backgroundColor = .clear
        $0.allowsSelection = true
        $0.isUserInteractionEnabled = true
        $0.allowsMultipleSelection = true
    }
    
    public let nextBtn = longCustomBtn(title: "다음", isEnabled: false)
    
    private func setupView() {
        [
            progressBar,
            titleLabel,
            subtitleLabel,
            eventCollectionView,
            nextBtn
        ].forEach {
            addSubview($0)
        }
        
        progressBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(4)
        }
            
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        eventCollectionView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            $0.bottom.equalTo(nextBtn.snp.top).offset(-12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        nextBtn.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(12)
        }
    }
}
