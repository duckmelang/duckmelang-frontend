//
//  SelectFavoriteCelebView.swift
//  Duckmelang
//
//  Created by 김연우 on 1/28/25.
//

import UIKit
import Then
import SnapKit

class SelectFavoriteCelebView: UIView, UITextFieldDelegate {
    
    private let titleLabel = UILabel().then {
        $0.text = "좋아하는 아이돌을 알려주세요!"
        $0.font = UIFont.aritaBoldFont(ofSize: 20)
        $0.textColor = .grey800
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "언제든 변경할 수 있어요"
        $0.font = UIFont.ptdRegularFont(ofSize: 13)
        $0.textColor = .grey600
    }
    
    private let celebTextField = UITextField().then {
        $0.placeholder = "텍스트 입력"
        $0.borderStyle = .roundedRect
        $0.keyboardType = .asciiCapable
        $0.returnKeyType = .done

        // 왼쪽 패딩 추가
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        $0.leftView = leftPaddingView
        $0.leftViewMode = .always

        // 돋보기 아이콘 추가 (오른쪽)
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .grey600
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        searchIcon.center = CGPoint(x: rightPaddingView.frame.width / 2, y: rightPaddingView.frame.height / 2)
        rightPaddingView.addSubview(searchIcon)

        $0.rightView = rightPaddingView
        $0.rightViewMode = .always
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 24
        layout.sectionInset = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
        layout.itemSize = CGSize(width: 88, height: 132)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(IdolCollectionViewCell.self, forCellWithReuseIdentifier: "IdolCollectionViewCell")
        return collectionView
    }()
    
    private var selectableIdols: [SelectableIdol] = []
    
    var isSelected: ((Int, Bool) -> Void)?
    var onTextInput: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [
            titleLabel,
            subtitleLabel,
            celebTextField,
            collectionView
        ].forEach {
            addSubview($0)
        }
            
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
        }
            
        celebTextField.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        collectionView.register(IdolCollectionViewCell.self, forCellWithReuseIdentifier: "IdolCollectionViewCell")
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(celebTextField.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        celebTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        celebTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 키보드 닫기
        return true
    }
    
    func updateCollectionView(with idols: [SelectableIdol]) {
        self.selectableIdols = idols
        collectionView.reloadData()
    }
    
    func resetTextField(){
        celebTextField.text = ""
        onTextInput?("")
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        let query = textField.text?.lowercased() ?? ""
        
        if query.isEmpty {
            // ✅ 검색어가 비었을 때: 전체 목록 보여주기
            collectionView.isHidden = false
            onTextInput?("")
        } else {
            // ✅ 검색어가 있을 때: 필터링된 목록 보여주기
            collectionView.isHidden = false
            onTextInput?(query)
        }
    }
}

extension SelectFavoriteCelebView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectableIdols.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IdolCollectionViewCell", for: indexPath) as? IdolCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let idol = selectableIdols[indexPath.item]
        cell.configure(with: idol.idol, isSelected: idol.isSelected)
        
        return cell
    }
}

extension SelectFavoriteCelebView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectableIdols[indexPath.item].isSelected.toggle()
        isSelected?(selectableIdols[indexPath.item].idol.idolId, selectableIdols[indexPath.item].isSelected)
        collectionView.reloadItems(at: [indexPath])
    }
}
