//
//  PostRecommendedFilterCell.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/27/25.
//

import UIKit

class PostRecommendedFilterCell: UICollectionViewCell {
    
    static let identifier = "PostRecommendedFilterCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let filter = paddingLabel(text: "", font: .ptdMediumFont(ofSize: 13), color: .grey0).then {
        $0.textInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 32)
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.backgroundColor = .dmrBlue
    }
    
    let deleteBtn = UIButton().then {
        $0.setImage(.filterDelete, for: .normal)
    }
    
    private func setupView(){
        [filter, deleteBtn].forEach{addSubview($0)}
        
        filter.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        deleteBtn.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
            $0.height.width.equalTo(12)
        }
    }
    
    public func configure(model: PostRecommendedFilterModel) {
        self.filter.text = model.filter
    }
}
