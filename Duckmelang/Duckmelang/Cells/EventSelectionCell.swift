//
//  EventSelectionCell.swift
//  Duckmelang
//
//  Created by 주민영 on 3/8/25.
//

import UIKit

class EventSelectionCell: UICollectionViewCell {
    static let identifier = "EventSelectionCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            btn.backgroundColor = isSelected ? .dmrBlue : .clear
            btn.setTitleColor(isSelected ? .white : .black, for: .normal)
            btn.layer.borderWidth = isSelected ? 0 : 0.7
        }
    }
    
    lazy var btn = UIButton().then {
        $0.layer.cornerRadius = 13
        $0.layer.borderWidth = 0.7
        $0.layer.borderColor = UIColor.grey300?.cgColor
        $0.titleLabel?.font = UIFont.ptdRegularFont(ofSize: 13)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.white, for: .selected)
        $0.isUserInteractionEnabled = false
        $0.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
    }
    
    private func setupView() {
        addSubview(btn)
        
        btn.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public func configure(event: EventDTO) {
        btn.setTitle(event.eventName, for: .normal)
        btn.tag = event.eventId
        btn.sizeToFit()
    }
}
