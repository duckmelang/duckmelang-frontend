//
//  PostRecommendedFilterChangeView.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class XKeywordChangeView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addStack()
        setupView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backBtn = UIButton().then {
        $0.setImage(.back, for: .normal)
    }
    
    private lazy var xKeywordChangeTitle = Label(text: "지뢰 키워드 변경", font: .aritaSemiBoldFont(ofSize: 18), color: .black)
    
    lazy var finishBtn = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("완료", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 13), .foregroundColor: UIColor.dmrBlue!]))
        $0.configuration = config
        $0.setTitleColor(.dmrBlue, for: .normal)
        $0.backgroundColor = .clear
    }
    
    lazy var searchBar = TextField().then {
        $0.configLabel(text: "", font: .ptdRegularFont(ofSize: 15), color: .grey900!)
        $0.configTextField(placeholder: "텍스트 입력", leftView: UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0)), leftViewMode: .always, interaction: true)
        $0.configLayer(layerBorderWidth: 1, layerCornerRadius: 5, layerColor: .grey400)
    }
    
    lazy var searchIcon = UIButton().then {
        $0.setImage(.addBtn2, for: .normal)
    }
    
    let xKeywordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 16
        $0.minimumInteritemSpacing = 16
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.itemSize = CGSize(width: 67, height: 38)
    }).then {
        $0.backgroundColor = .clear
        $0.register(PostRecommendedFilterCell.self, forCellWithReuseIdentifier: PostRecommendedFilterCell.identifier)
    }
    
    private lazy var topStack = Stack(axis: .horizontal, distribution: .equalCentering, alignment: .center)
    
    private func addStack(){
        [backBtn, xKeywordChangeTitle, finishBtn].forEach{topStack.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [topStack, searchBar, searchIcon, xKeywordCollectionView].forEach{addSubview($0)}
        
        topStack.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(42)
        }
        
        searchBar.snp.makeConstraints{
            $0.top.equalTo(topStack.snp.bottom).offset(10)
            $0.height.equalTo(39)
            $0.width.equalTo(topStack.snp.width)
            $0.centerX.equalToSuperview()
        }
        
        searchIcon.snp.makeConstraints{
            $0.centerY.equalTo(searchBar.snp.centerY)
            $0.trailing.equalTo(searchBar.snp.trailing).inset(16)
        }
        
        xKeywordCollectionView.snp.makeConstraints{
            $0.top.equalTo(searchBar.snp.bottom).offset(22)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.greaterThanOrEqualToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
}


