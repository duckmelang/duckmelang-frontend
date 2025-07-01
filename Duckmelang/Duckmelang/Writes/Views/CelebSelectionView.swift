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
    
    lazy var allPostSeeBtn = UIButton().then {
        $0.backgroundColor = .white
        var config = UIButton.Configuration.plain()
        var imageConfig = UIImage.SymbolConfiguration(pointSize: 20)

        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)!.withTintColor(UIColor.grey500!, renderingMode: .alwaysOriginal)
        
        config.attributedTitle = AttributedString("전체보기", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 16), .foregroundColor: UIColor.grey400!]))
        
        config.contentInsets = NSDirectionalEdgeInsets(top: -20, leading: 0, bottom: 0, trailing: 0)
        
        config.image = image
        config.imagePlacement = .trailing
        config.imagePadding = 16
        $0.configuration = config
    }
    
    private func setupView() {
        addSubview(collectionView)
        addSubview(allPostSeeBtn)
        
        allPostSeeBtn.snp.makeConstraints{
            $0.width.equalToSuperview()
            $0.height.equalTo(73)
            $0.bottom.equalTo(safeAreaInsets.bottom)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(allPostSeeBtn.snp.top)
        }
    }
}
