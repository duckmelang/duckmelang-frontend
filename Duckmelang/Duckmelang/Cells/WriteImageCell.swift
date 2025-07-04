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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    func configure(image: UIImage) {
        imageView.image = image
    }
}
