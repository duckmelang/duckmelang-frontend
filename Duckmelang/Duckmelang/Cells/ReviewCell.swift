//
//  ReviewCell.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/23/25.
//

import UIKit

class ReviewCell: UITableViewCell {
    static let identifier = "ReviewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.addStack()
        self.setupView()

        warningBtn.addTarget(self, action: #selector(warningBtnTapped), for: .touchUpInside)
        bringSubviewToFront(warningBtn)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nickname.text = nil
        self.gender.text = nil
        self.line.text = nil
        self.age.text = nil
        self.review.text = nil
    }
    
    var onTapped: (() -> Void)?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nickname = Label(text: "닉네임", font: .ptdSemiBoldFont(ofSize: 14), color: .grey700)
    
    let gender = Label(text: "여성", font: .ptdMediumFont(ofSize: 13), color: .grey600)
    
    let line = Label(text: "ㅣ", font: .ptdMediumFont(ofSize: 13), color: .grey400)
    
    let age = Label(text: "나이", font: .ptdMediumFont(ofSize: 13), color: .grey600)
    
    let review = paddingLabel(text: "", font: .ptdRegularFont(ofSize: 13), color: .grey800).then {
        $0.backgroundColor = .grey100
        $0.layer.cornerRadius = 7
        $0.layer.masksToBounds = true
        $0.lineBreakMode = .byCharWrapping
        $0.textInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        $0.lineBreakMode = .byCharWrapping
    }
    
    let warningBtn = UIButton().then {
        var config = UIButton.Configuration.plain()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12)
        let image = UIImage(systemName: "exclamationmark.triangle", withConfiguration: imageConfig)
        config.imagePlacement = .top
        config.imagePadding = 5
        $0.configuration = config
        config.attributedTitle = AttributedString("", attributes: AttributeContainer([.font: UIFont.ptdRegularFont(ofSize: 12), .foregroundColor: UIColor.grey600!]))
        config.image = image
        $0.tintColor = UIColor.grey600
        $0.configuration = config
        $0.isUserInteractionEnabled = true
    }
    
    let genderAndAgeStack = Stack(axis: .horizontal, spacing: -19, distribution: .equalSpacing)

    let nicknameAndInfr = Stack(axis: .vertical, spacing: 5, alignment: .leading)

    private func addStack(){
        [gender, line, age].forEach{genderAndAgeStack.addArrangedSubview($0)}
        [nickname, genderAndAgeStack].forEach{nicknameAndInfr.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [nicknameAndInfr, review, warningBtn].forEach{contentView.addSubview($0)}
        
        nicknameAndInfr.snp.makeConstraints{
            $0.height.equalTo(40)
            $0.top.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(100)
        }
        
        review.snp.makeConstraints{
            $0.height.equalTo(48)
            $0.leading.equalTo(nicknameAndInfr.snp.trailing).offset(12)
            $0.top.equalToSuperview().inset(12)
            $0.trailing.equalTo(warningBtn.snp.leading).offset(-9)
        }
        
        warningBtn.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.width.equalTo(24)
            $0.trailing.equalToSuperview().inset(12)
        }
    }
    
    public func configure(model: ReviewModel) {
        self.nickname.text = model.nickname
        self.gender.text = model.gender
        self.age.text = model.age
        self.review.text = model.review
    }
    
    public func configure(model: myReviewDTO, reviewCount: Int ,matchingCount: Int, onTapped: @escaping () -> Void) {
        self.nickname.text = model.nickname
        self.gender.text = model.gender == "true" ? "남성" : "여성"
        self.age.text = "만 \(model.age)세"
        self.review.text = model.content
        self.warningBtn.configuration?.attributedTitle = AttributedString("\(reviewCount)/\(matchingCount)", attributes: AttributeContainer([.font: UIFont.ptdRegularFont(ofSize: 12), .foregroundColor: UIColor.grey600!]))
        self.onTapped = onTapped
    }
    
    public func configure(model: OtherReviewDTO) {
        self.nickname.text = model.nickname
        self.gender.text = model.gender == "true" ? "남성" : "여성"
        self.age.text = "만 \(model.age)세"
        self.review.text = model.content
    }
  
    @objc private func warningBtnTapped() {
        print("신고 버튼 눌림")
        onTapped?()
    }
}
