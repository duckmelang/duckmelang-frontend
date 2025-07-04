//
//  FilterKeywordsView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/28/25.
//

import UIKit
import Then
import SnapKit

class FilterKeywordsView: UIView, UITextFieldDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let progressBar = ProgressBarView(currentStep: 3)
    
    private let titleLabel = UILabel().then {
        $0.text = "피하고싶은 키워드를 알려주세요!"
        $0.font = UIFont.aritaBoldFont(ofSize: 20)
        $0.textColor = .grey800
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "해당 키워드가 포함된 게시글은 필터가 씌워져요."
        $0.font = UIFont.ptdRegularFont(ofSize: 13)
        $0.textColor = .grey600
    }
    
    public lazy var plusButton = UIButton(type: .system).then {
        let image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = .grey600
        $0.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
    }
    
    public lazy var filterKeywordTextField = UITextField().then {
        $0.placeholder = "텍스트 입력"
        $0.borderStyle = .roundedRect
        $0.returnKeyType = .done

        // 왼쪽 패딩 추가
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        $0.leftView = leftPaddingView
        $0.leftViewMode = .always
        
        let rightContainer = UIView(frame: CGRect(x: 0, y: 0, width: 56, height: 56))
        plusButton.center = CGPoint(x: rightContainer.frame.width / 2, y: rightContainer.frame.height / 2)
        rightContainer.addSubview(plusButton)

        $0.rightView = rightContainer
        $0.rightViewMode = .always
    }

    public lazy var keywordsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 80, height: 30)
        layout.minimumInteritemSpacing = 10  // 좌우 간격
        layout.minimumLineSpacing = 17  // 위아래 간격
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(KeywordCell.self, forCellWithReuseIdentifier: KeywordCell.identifier)
        return collectionView
    }()
    
    public let nextBtn = longCustomBtn(title: "다음", isEnabled: true)
    
    private func setupView() {
        [
            progressBar,
            titleLabel,
            subtitleLabel,
            filterKeywordTextField,
            keywordsCollectionView,
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
            
        filterKeywordTextField.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        keywordsCollectionView.snp.makeConstraints{
            $0.top.equalTo(filterKeywordTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(nextBtn.snp.top).inset(20)
        }
        
        nextBtn.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(12)
        }
    }
}
