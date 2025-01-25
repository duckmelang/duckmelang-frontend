//
//  MessageView.swift
//  Duckmelang
//
//  Created by 주민영 on 1/21/25.
//

import UIKit

class MessageView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var topView = TopMessageView(isMyFirstMessage: true)
    
    let messageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = .init(width: 375, height: 58)
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 0
    }).then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.register(
            MyMessageCell.self,
            forCellWithReuseIdentifier: MyMessageCell.identifier
        )
        $0.register(
            OtherMessageCell.self,
            forCellWithReuseIdentifier: OtherMessageCell.identifier
        )
        $0.register(
            DateHeaderCell.self,
            forCellWithReuseIdentifier: DateHeaderCell.identifier
        )
    }
    
    let bottomView = BottomMessageView()
    
    private func setupView() {
        [
            topView,
            messageCollectionView,
            bottomView,
        ].forEach {
            addSubview($0)
        }
        
        topView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(-5)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        messageCollectionView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(-5)
            $0.trailing.equalToSuperview().offset(5)
            $0.height.equalTo(60)
        }
    }

}
