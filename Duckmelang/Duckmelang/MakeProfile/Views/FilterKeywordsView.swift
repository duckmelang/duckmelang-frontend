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
    
    private let filterKeywordTextField = UITextField().then {
        $0.placeholder = "텍스트 입력"
        $0.borderStyle = .roundedRect
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

    public let keywordsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(KeywordCell.self, forCellWithReuseIdentifier: KeywordCell.identifier)
        return collectionView
    }()
    
    public var keywords: [String] = [] {
        didSet {
            keywordsCollectionView.reloadData()
        }
    }
    
    var onTextInput: ((String) -> Void)?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupView()
        
        keywordsCollectionView.dataSource = self
        keywordsCollectionView.delegate = self
        
        filterKeywordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        filterKeywordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty, !keywords.contains(text) else {
            return false
        }
        
        keywords.append(text)
        
        textField.text = ""
        textField.becomeFirstResponder()
        
        return true
    }

    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let query = textField.text?.lowercased() ?? ""
        
        if query.isEmpty {
            keywordsCollectionView.isHidden = true
            onTextInput?("")
        } else {
            keywordsCollectionView.isHidden = false
            onTextInput?(query)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        [
            titleLabel,
            subtitleLabel,
            filterKeywordTextField,
            keywordsCollectionView
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
            
        filterKeywordTextField.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        keywordsCollectionView.snp.makeConstraints{
            $0.top.equalTo(filterKeywordTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}

extension FilterKeywordsView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCell.identifier, for: indexPath) as? KeywordCell else {
            return UICollectionViewCell()
        }
        let keyword = keywords[indexPath.row]
        cell.configure(with: keyword)
        cell.deleteAction = { [weak self] in
            self?.keywords.remove(at: indexPath.row)
            self?.keywordsCollectionView.reloadData()
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Keyword: \(keywords[indexPath.row])")
    }
}

