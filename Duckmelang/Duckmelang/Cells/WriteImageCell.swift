//
//  WriteImageCell.swift
//  Duckmelang
//
//  Created by nau on 7/4/25.
//

import UIKit

class WriteImageCell: UICollectionViewCell {
    
    static let identifier = "WriteImageCell"
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let deleteBtn = UIButton().then {
        $0.setImage(.deleteIdol, for: .normal)
    }
    
    var onDelete: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupAction()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        contentView.addSubview(imageView)
        contentView.addSubview(deleteBtn)
        
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        deleteBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(12)
            $0.width.height.equalTo(24)
        }
    }
    
    private func setupAction() {
        deleteBtn.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
    }
    
    @objc private func deleteBtnTapped() {
        onDelete?()
    }
    
    func configure(image: UIImage, onDelete: @escaping () -> Void) {
        imageView.image = image
        self.onDelete = onDelete
    }
}
