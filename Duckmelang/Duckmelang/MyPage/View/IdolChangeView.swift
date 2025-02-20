//
//  IdolChangeView.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit

class IdolChangeView: UIView {
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
    
    private lazy var idolChangeTitle = Label(text: "아이돌 변경", font: .aritaSemiBoldFont(ofSize: 18), color: .black)
    
    lazy var finishBtn = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("완료", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 13), .foregroundColor: UIColor.dmrBlue!]))
        $0.configuration = config
        $0.setTitleColor(.dmrBlue, for: .normal)
        $0.backgroundColor = .clear
    }
    
    let idolChangeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: LeftAlignedCollectionViewFlowLayout().then {
        $0.estimatedItemSize = .init(width: 88, height: 108)
        $0.minimumInteritemSpacing = 26
    }).then {
        $0.backgroundColor = .clear
        $0.register(IdolChangeCell.self, forCellWithReuseIdentifier: IdolChangeCell.identifier)
        $0.register(IdolAddBtnCell.self, forCellWithReuseIdentifier: IdolAddBtnCell.identifier)
    }

    private lazy var topStack = Stack(axis: .horizontal, distribution: .equalCentering, alignment: .center)
    
    private func addStack(){
        [backBtn, idolChangeTitle, finishBtn].forEach{topStack.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [topStack, idolChangeCollectionView].forEach{addSubview($0)}
        
        topStack.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(42)
        }
        
        idolChangeCollectionView.snp.makeConstraints{
            $0.top.equalTo(topStack.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.bottom.equalToSuperview()
        }
    }
}
