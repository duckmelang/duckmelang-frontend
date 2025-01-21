//
//  CelebCollectionViewCell.swift
//  Duckmelang
//
//  Created by 김연우 on 1/18/25.
//

import UIKit
import SnapKit

class CelebCell: UICollectionViewCell {
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 24
        $0.layer.masksToBounds = true
        $0.clipsToBounds = true
    }

    private let nameLabel = UILabel().then {
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 16)
    }
    
    private let checkmarkIcon = UIImageView().then {
        $0.image = UIImage(named: "selected")
        $0.isHidden = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(checkmarkIcon)

        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(48)
        }

        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
            $0.centerY.equalToSuperview()
        }

        checkmarkIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-15)
            $0.centerY.equalToSuperview()
        }
    }

    func configure(with celeb: Celeb, isSelected: Bool) {
        profileImageView.image = UIImage(named: celeb.imageName)
        nameLabel.text = celeb.name
        nameLabel.textColor = isSelected ? .black : .grey400
        checkmarkIcon.isHidden = !isSelected
    }
}
