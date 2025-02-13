//
//  IdolChangeCell.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/27/25.
//

import UIKit

class IdolChangeCell: UICollectionViewCell {
    
    static let identifier = "IdolChangeCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let deleteBtn = UIButton().then {
        $0.setImage(.deleteIdol, for: .normal)
    }
    
    var idolImage = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = $0.frame.width/2
    }
    
    let idolName = Label(text: "", font: .ptdRegularFont(ofSize: 16), color: .grey800)
    
    private func setupView() {
        [idolImage, deleteBtn, idolName].forEach{addSubview($0)}
        
        idolImage.snp.makeConstraints{
            $0.top.equalToSuperview().inset(6)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(64)
        }
        
        deleteBtn.snp.makeConstraints{
            $0.top.trailing.equalToSuperview()
            $0.height.width.equalTo(24)
        }
        
        idolName.snp.makeConstraints{
            $0.top.equalTo(idolImage.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    public func configure(model: IdolChangeModel, isLastCell: Bool) {
        self.idolName.text = model.idolName
        self.idolImage.image = model.idolImage
        
        if isLastCell {
            // 마지막 셀의 다른 스타일 적용
            self.idolName.textColor = .grey600
            self.deleteBtn.isHidden = true
        }
    }
    
    func configure(model: IdolListDTO, isLastCell: Bool) {
        idolName.text = model.idolName
        idolImage.kf.setImage(with: URL(string: model.idolImage))
        
        idolImage.contentMode = .scaleAspectFill
        idolImage.layer.masksToBounds = true
        idolImage.layer.cornerRadius = 32
    }
}

class IdolAddCell: UICollectionViewCell {
    
    static let identifier = "IdolAddCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var idolImage = UIImageView().then {
        $0.image = UIImage(resource: .idolAdd)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = $0.frame.width/2
    }
    
    let idolName = Label(text: "추가하기", font: .ptdRegularFont(ofSize: 16), color: .grey600)
    
    private func setupView() {
        [idolImage, idolName].forEach{addSubview($0)}
        
        idolImage.snp.makeConstraints{
            $0.top.equalToSuperview().inset(6)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(64)
        }
        
        idolName.snp.makeConstraints{
            $0.top.equalTo(idolImage.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
}
