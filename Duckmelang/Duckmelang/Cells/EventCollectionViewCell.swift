//
//  EventCollectionViewCell.swift
//  Duckmelang
//
//  Created by 김연우 on 2/20/25.
//

import UIKit
import Then
import SnapKit

class EventCollectionViewCell: UICollectionViewCell {
    static let identifier = "EventCollectionViewCell"
    
    
    
    public let eventButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(eventButton)
        
        eventButton.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.bottom.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview().offset(12)
        }
        
        eventButton.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureEventButton(title: String, isSelected: Bool) {
        var config = UIButton.Configuration.filled()
        config.title = title
        eventButton.titleLabel?.numberOfLines = 1
        eventButton.titleLabel?.textAlignment = .center
        config.baseForegroundColor = isSelected ? .white : .grey400
        config.baseBackgroundColor = isSelected ? .dmrBlue : .white
        config.attributedTitle?.font = .ptdSemiBoldFont(ofSize: 14)
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16) // 내부 패딩

        eventButton.configuration = config
        eventButton.layer.cornerRadius = 15
        eventButton.layer.borderWidth = 1
        eventButton.layer.borderColor = isSelected ? UIColor.dmrBlue!.cgColor : UIColor.grey400!.cgColor
        eventButton.clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = true
    }
}
