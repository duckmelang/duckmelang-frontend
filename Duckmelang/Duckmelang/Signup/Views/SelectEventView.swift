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
    
    public lazy var eventCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 80, height: 40)
        layout.minimumInteritemSpacing = 14  // 좌우 간격
        layout.minimumLineSpacing = 20  // 위아래 간격

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(EventSelectionCell.self, forCellWithReuseIdentifier: EventSelectionCell.identifier)
        cv.backgroundColor = .clear
        cv.allowsSelection = true
        cv.isUserInteractionEnabled = true
        cv.allowsMultipleSelection = true
        return cv
    }()
    
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
