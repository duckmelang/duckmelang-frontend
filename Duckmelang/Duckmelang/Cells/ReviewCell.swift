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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nickname.text = nil
        self.gender.text = nil
        self.line.text = nil
        self.age.text = nil
        self.review.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nickname = Label(text: "닉네임", font: .ptdSemiBoldFont(ofSize: 14), color: .grey700)
    
    let gender = Label(text: "여성", font: .ptdMediumFont(ofSize: 13), color: .grey600)
    
    let line = Label(text: "ㅣ", font: .ptdMediumFont(ofSize: 13), color: .grey400)
    
    let age = Label(text: "나이", font: .ptdMediumFont(ofSize: 13), color: .grey600)
    
    let review = paddingLabel(text: "엄청 친절하세요! 저랑 대화도 잘 통해서 좋았습니다 :)", font: .ptdRegularFont(ofSize: 13), color: .grey800).then {
        $0.backgroundColor = .grey100
        $0.layer.cornerRadius = 7
        $0.layer.masksToBounds = true
        $0.textInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
    }
    
    let genderAndAgeStack = Stack(axis: .horizontal)
    let nicknameAndInfr = Stack(axis: .vertical, spacing: 5, alignment: .leading)

    private func addStack(){
        [gender, line, age].forEach{genderAndAgeStack.addArrangedSubview($0)}
        [nickname, genderAndAgeStack].forEach{nicknameAndInfr.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [nicknameAndInfr, review].forEach{addSubview($0)}
        
        nicknameAndInfr.snp.makeConstraints{
            $0.height.equalTo(40)
            $0.top.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(70)
        }
        
        review.snp.makeConstraints{
            $0.height.equalTo(48)
            $0.width.equalTo(255)
            $0.top.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    public func configure(model: ReviewModel) {
        self.nickname.text = model.nickname
        self.gender.text = model.gender
        self.age.text = model.age
        self.review.text = model.review
    }
    
    public func configure(model: myReviewDTO) {
        self.nickname.text = model.nickname
        self.gender.text = model.gender == "true" ? "남성" : "여성"
        self.age.text = "\(model.age)세"
        self.review.text = model.content
    }
    
    public func configure(model: OtherReviewDTO) {
        self.nickname.text = model.nickname
        self.gender.text = model.gender == "true" ? "남성" : "여성"
        self.age.text = "\(model.age)세"
        self.review.text = model.content
    }
}
