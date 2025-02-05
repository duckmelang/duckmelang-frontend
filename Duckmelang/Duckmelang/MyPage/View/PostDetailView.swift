//
//  PostDetailView.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import SnapKit

class PostDetailView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addStack()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var contentView = UIView()
    
    //이미지뷰, 프로필info, 진행중btn
    lazy var postDetailTopView = PostDetailTopView()
    
    lazy var postDetailBottomView = PostDetailBottomView()
    
    lazy var backBtn = UIButton().then {
        $0.setImage(.back, for: .normal)
    }
    
    private lazy var title = Label(text: "내 게시글", font: .aritaSemiBoldFont(ofSize: 18), color: .black)
    
    lazy var finishBtn = UIButton().then {
        $0.setImage(.moreVertical, for: .normal)
    }
    
    private lazy var topStack = Stack(axis: .horizontal, distribution: .equalCentering, alignment: .center)
    
    private func addStack(){
        [backBtn, title, finishBtn].forEach{topStack.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [scrollView].forEach{addSubview($0)}
        [contentView].forEach{scrollView.addSubview($0)}
        [postDetailTopView, postDetailBottomView].forEach{contentView.addSubview($0)}
        
        addSubview(topStack)
        
        topStack.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(42)
        }
        
        scrollView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints{
            $0.edges.width.equalToSuperview()
            $0.height.greaterThanOrEqualToSuperview()
        }
        
        postDetailTopView.snp.makeConstraints{
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        postDetailBottomView.snp.makeConstraints{
            $0.top.equalTo(postDetailTopView.profileInfo.snp.bottom).offset(16)
        }
        
    }
}

class PostDetailTopView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        self.clipsToBounds = false
        
        addStack()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var imageView = UIScrollView().then {
        $0.backgroundColor = .grey200
        $0.isPagingEnabled = true
    }
    
    private lazy var imageViews: [UIImageView] = []
    
    lazy var profileImage = UIImageView().then {
        $0.image = .profile
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 18
        $0.clipsToBounds = true
    }
    
    lazy var nickname = Label(text: "닉네임", font: .ptdSemiBoldFont(ofSize: 14), color: .black)
    
    private lazy var gender = Label(text: "여성", font: .ptdRegularFont(ofSize: 13), color: .grey600)
    
    private lazy var line = Label(text: "ㅣ", font: .ptdRegularFont(ofSize: 13), color: .grey400)
    
    private lazy var age = Label(text: "나이", font: .ptdRegularFont(ofSize: 13), color: .grey600)
    
    lazy var progressBtn = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 19)
        $0.backgroundColor = .clear
        config.attributedTitle = AttributedString("진행 중", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 13), .foregroundColor: UIColor.grey800!]))
        config.image = .progress
        config.imagePlacement = .trailing
        config.imagePadding = 10
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.grey400?.cgColor
        $0.layer.borderWidth = 1
        $0.configuration = config
        $0.isHidden = false
    }
    
    lazy var progressTapBtn = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        $0.backgroundColor = .clear
        config.attributedTitle = AttributedString("진행 중", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 13), .foregroundColor: UIColor.grey800!]))
        config.attributedSubtitle = AttributedString("완료", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 13), .foregroundColor: UIColor.grey500!]))
        config.titleAlignment = .center
        config.titlePadding = 12
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.grey400?.cgColor
        $0.layer.borderWidth = 1
        $0.configuration = config
        $0.isHidden = true
    }
    
    lazy var endBtn = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 19)
        $0.backgroundColor = .clear
        config.attributedTitle = AttributedString("완료", attributes: AttributeContainer([.font: UIFont.ptdSemiBoldFont(ofSize: 13), .foregroundColor: UIColor.grey800!]))
        config.image = .progress
        config.imagePlacement = .trailing
        config.imagePadding = 10
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.grey400?.cgColor
        $0.layer.borderWidth = 1
        $0.configuration = config
        $0.isHidden = true
    }
    
    lazy var genderAndAgeStack = Stack(axis: .horizontal, spacing: 1)
    lazy var nicknameAndInfo = Stack(axis: .vertical, spacing: 6)
    lazy var profileInfo = Stack(axis: .horizontal, spacing: 16, alignment: .center)
    
    private func addGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = imageView.bounds

        //그라데이션 색상 설정 (위는 투명, 아래는 검정)
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black!.withAlphaComponent(0.5).cgColor
        ]

        //그라데이션 방향 설정 (위 → 아래)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

        //`imageView`의 `layer`에 추가
        imageView.layer.addSublayer(gradientLayer)
    }
    
    private func addStack(){
        [gender, line, age].forEach{genderAndAgeStack.addArrangedSubview($0)}
        [nickname, genderAndAgeStack].forEach{nicknameAndInfo.addArrangedSubview($0)}
        [profileImage,nicknameAndInfo].forEach{profileInfo.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [imageView, profileInfo, progressBtn, progressTapBtn, endBtn].forEach{addSubview($0)}
    
        imageView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(-(UIApplication.shared.windows.first?.safeAreaInsets.top)!) //Safe Area 고려하여 확장\
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height * 0.45)
        }
        
        //그라데이션 추가
        DispatchQueue.main.async {
            self.addGradientLayer()
        }
        
        profileImage.snp.makeConstraints{
            $0.height.width.equalTo(36)
        }
        
        profileInfo.snp.makeConstraints{
            $0.top.equalTo(imageView.snp.bottom).offset(15)
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        progressBtn.snp.makeConstraints{
            $0.top.equalTo(imageView.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(92)
        }
        
        progressTapBtn.snp.makeConstraints{
            $0.top.equalTo(imageView.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(92)
        }
        
        endBtn.snp.makeConstraints{
            $0.top.equalTo(imageView.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(92)
        }
    }
}

class PostDetailBottomView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addStack()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var title1 = Label(text: "게시글 제목", font: .ptdSemiBoldFont(ofSize: 17), color: .grey900)
    
    private lazy var body = Label(text: "본문 \n", font: .ptdRegularFont(ofSize: 15), color: .grey900)
    
    private lazy var info = Label(text: "스크랩 0      | 채팅 0      | 조회 0 ", font: .ptdRegularFont(ofSize: 12), color: .grey500)
    private lazy var textStack = Stack(axis: .vertical, spacing: 8)
    
    private lazy var title2 = Label(text: "동행 정보", font: .ptdSemiBoldFont(ofSize: 17), color: .grey900)
    
    let tableView = UITableView().then {
        $0.register(PostDetailAccompanyCell.self, forCellReuseIdentifier: PostDetailAccompanyCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 36
    }
    
    private func addStack(){
        [title1, body, info].forEach{textStack.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [textStack, title2, tableView].forEach{addSubview($0)}
        
        textStack.snp.makeConstraints{
            $0.top.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        title2.snp.makeConstraints{
            $0.top.equalTo(textStack.snp.bottom).offset(60)
            $0.leading.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(title2.snp.bottom).offset(12)
            $0.width.equalTo(UIScreen.main.bounds.width - 32)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(500)//수정예정
        }
    }
}
