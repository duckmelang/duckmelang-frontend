//
//  IdolCollectionViewCell.swift
//  Duckmelang
//
//  Created by 김연우 on 2/19/25.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class IdolCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "IdolCollectionViewCell"
    
    private let idolImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 32 // 원형 이미지 (64*64 기준)
        $0.layer.masksToBounds = true
    }
    
    private let idolImageShadowView = UIImageView().then {
        $0.layer.shadowOffset = CGSize(width: 5, height: 5)
        $0.layer.shadowOpacity = 0.7
        $0.layer.shadowRadius = 5
        $0.layer.shadowColor = UIColor.black!.cgColor
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let idolNameLabel = UILabel().then {
        $0.font = UIFont.ptdRegularFont(ofSize: 16)
        $0.textColor = .grey800
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(idolImageView)
        contentView.addSubview(idolImageShadowView)
        contentView.addSubview(idolNameLabel)
        
        idolImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(64)
        }
        
        idolImageShadowView.snp.makeConstraints{
            $0.centerY.equalTo(idolImageView)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(66)
        }
        
        idolNameLabel.snp.makeConstraints {
            $0.top.equalTo(idolImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
    }
    
    func configure(with idol: Idol, isSelected: Bool) {
        idolNameLabel.text = idol.idolName
        idolNameLabel.textColor = isSelected ? .dmrBlue : .grey800
        idolImageView.layer.borderColor = isSelected ? UIColor.dmrBlue!.cgColor : UIColor.clear.cgColor
        idolImageView.layer.borderWidth = isSelected ? 2 : 0
        
        if let imageUrl = URL(string: idol.idolImage) {
            idolImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholder"))
        }
    }
}
