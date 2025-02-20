//
//  CelebSelectionView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/18/25.
//

import UIKit

class CelebSelectionView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(
            width: UIScreen.main.bounds.width - 40,
            height: 65
        )
        layout.minimumLineSpacing = 10

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .white
        collectionView
            .register(CelebCell.self, forCellWithReuseIdentifier: "CelebCell")
        return collectionView
    }()
    
    private func setupView() {
        addSubview(collectionView)

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
    }
}
