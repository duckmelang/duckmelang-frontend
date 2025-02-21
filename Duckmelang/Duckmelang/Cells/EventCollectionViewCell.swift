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
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.ptdSemiBoldFont(ofSize: 14)
            return outgoing
        }

        eventButton.configuration = config
        eventButton.layer.cornerRadius = 15
        eventButton.layer.borderWidth = 1
        eventButton.layer.borderColor = isSelected ? UIColor.dmrBlue!.cgColor : UIColor.grey400!.cgColor
        eventButton.clipsToBounds = true
        
        eventButton.setNeedsLayout()
        eventButton.layoutIfNeeded()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = true
    }
}
