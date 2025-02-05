//
//  AccompanyInfoCell.swift
//  Duckmelang
//
//  Created by KoNangYeon on 2/5/25.
//

import UIKit

class PostDetailAccompanyCell: UITableViewCell {
    static let identifier = "PostDetailAccompanyCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let title = Label(text: "", font: .ptdRegularFont(ofSize: 15), color: .grey600)
    
    private let info = paddingLabel(text: "d", font: .ptdRegularFont(ofSize: 13), color: .grey800).then {
        $0.textInsets = UIEdgeInsets(top:6, left: 12, bottom: 6, right: 12)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        $0.layer.borderColor = UIColor.grey300?.cgColor
        $0.layer.borderWidth = 1
    }
    
    private func setupView() {
        [title, info].forEach{addSubview($0)}
        
        title.snp.makeConstraints{
            $0.centerY.leading.equalToSuperview()
        }
        
        info.snp.makeConstraints{
            $0.centerY.trailing.equalToSuperview()
        }
    }
    
    public func configure(model: PostDetailAccompanyModel) {
        self.title.text = model.title
        self.info.text = model.info
    }
}
