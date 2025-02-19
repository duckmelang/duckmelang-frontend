//
//  IdolAddView.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class IdolAddView: UIView {

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
    
    private lazy var idolAddTitle = Label(text: "아이돌 추가", font: .aritaSemiBoldFont(ofSize: 18), color: .black)
    
    lazy var finishBtn = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("완료", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 13), .foregroundColor: UIColor.dmrBlue!]))
        $0.configuration = config
        $0.setTitleColor(.dmrBlue, for: .normal)
        $0.backgroundColor = .clear
    }
    
    lazy var searchBar = TextField().then {
        $0.configLabel(text: "", font: .ptdRegularFont(ofSize: 15), color: .grey900!)
        $0.configTextField(placeholder: "아이돌명을 입력해주세요", leftView: UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0)), leftViewMode: .always, interaction: true)
        $0.configLayer(layerBorderWidth: 1, layerCornerRadius: 5, layerColor: .grey400)
    }
    
    lazy var searchIcon = UIButton().then {
        $0.setImage(.search, for: .normal)
    }
    
    let idolAddCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.itemSize = .init(width: 88, height: 108)
        $0.minimumInteritemSpacing = 26
    }).then {
        $0.backgroundColor = .white
        $0.register(IdolAddCell.self, forCellWithReuseIdentifier: IdolAddCell.identifier)
    }
    
    private lazy var topStack = Stack(axis: .horizontal, distribution: .equalCentering, alignment: .center)
    
    private func addStack(){
        [backBtn, idolAddTitle, finishBtn].forEach{topStack.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [topStack, searchBar, searchIcon, idolAddCollectionView].forEach{addSubview($0)}
        
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
        
        idolAddCollectionView.snp.makeConstraints{
            $0.top.equalTo(searchBar.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(400)
        }
    }
}
