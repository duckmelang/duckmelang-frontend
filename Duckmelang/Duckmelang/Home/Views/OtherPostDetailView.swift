//
//  PostDetailView.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//

import UIKit
import SnapKit
import Kingfisher

class OtherPostDetailView: UIView {

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
    
    lazy var postDetailTopView = OtherPostDetailTopView()
    
    lazy var postDetailBottomView = OtherPostDetailBottomView()
    
    lazy var tabBar = OtherPostDetailTapBar()
    
    lazy var backBtn = UIButton().then {
        $0.setImage(.back, for: .normal)
        $0.tintColor = .grey0
    }
    
    private lazy var title = Label(text: "", font: .aritaSemiBoldFont(ofSize: 18), color: .black)
    
    lazy var finishBtn = UIButton().then{
        $0.setTitle("", for: .normal)
    }
    
    private lazy var topStack = Stack(axis: .horizontal, distribution: .equalCentering, alignment: .center)
    
    private func addStack(){
        [backBtn, title, finishBtn].forEach{topStack.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [scrollView, tabBar].forEach{addSubview($0)}
        [contentView].forEach{scrollView.addSubview($0)}
        [postDetailTopView, postDetailBottomView].forEach{contentView.addSubview($0)}
        
        addSubview(topStack)
        
        tabBar.snp.makeConstraints{
            $0.height.equalTo(73)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        topStack.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(42)
        }
        
        scrollView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(tabBar.snp.top)
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
        
        scrollView.contentInset.bottom = 73 // 스크롤뷰가 tabBar 안가리도록..
    }
    
    // **UI 업데이트 함수**
    func updateUI(with data: MyPostDetailResponse) {
        // 이미지 로드 (첫 번째 이미지)
        if let firstImageUrlString = data.postImageUrl.first,
           let imageUrl = URL(string: firstImageUrlString) {
            postDetailTopView.updateImage(with: imageUrl) // ✅ 이미지 로드 후 그라데이션 추가
        }
        
        // 상단 프로필 정보 업데이트
        if let userImageUrl = URL(string: data.latestPublicMemberProfileImage ?? "") {
            self.postDetailTopView.profileImage.kf.setImage(with: userImageUrl, placeholder: UIImage())
        }
        postDetailTopView.nickname.text = data.nickname
        postDetailTopView.gender.text = (data.gender == "MALE") ? "남성" : "여성"
        postDetailTopView.age.text = "만 \(data.age)세"
        
        // 하단 게시글 정보 업데이트
        postDetailBottomView.title1.text = data.title
        postDetailBottomView.body.text = data.content
        postDetailBottomView.text1.text = "스크랩 \(data.bookmarkCount)"
        postDetailBottomView.text2.text = "| 채팅 \(data.chatCount)"
        postDetailBottomView.text3.text = "| 조회 \(data.viewCount)"
        
        postDetailBottomView.tableView.reloadData()
    }
}

class OtherPostDetailTopView: UIView {
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

    lazy var imageView = UIScrollView().then {
        $0.backgroundColor = .grey200
        $0.isPagingEnabled = true
    }
    
    private lazy var imageViews = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    lazy var profileImage = UIImageView().then {
        $0.image = .profile
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 18
        $0.clipsToBounds = true
    }
    
    lazy var nickname = Label(text: "닉네임", font: .ptdSemiBoldFont(ofSize: 14), color: .black)
    
    lazy var gender = Label(text: "여성", font: .ptdRegularFont(ofSize: 13), color: .grey600).then {
        $0.textAlignment = .left
    }
    
    private lazy var line = Label(text: "ㅣ", font: .ptdRegularFont(ofSize: 13), color: .grey400).then {
        $0.textAlignment = .left
    }
    
    lazy var age = Label(text: "나이", font: .ptdRegularFont(ofSize: 13), color: .grey600).then {
        $0.textAlignment = .left
    }

    lazy var genderAndAgeStack = Stack(axis: .horizontal, spacing: -10, distribution: .equalCentering)
    lazy var nicknameAndInfo = Stack(axis: .vertical, spacing: 6, alignment: .leading)
    lazy var profileInfo = Stack(axis: .horizontal, spacing: 16, alignment: .center)
    
    /// ✅ Kingfisher 이미지 로드 후 그라데이션 추가
    func updateImage(with url: URL?) {
        guard let url = url else { return }
        imageViews.kf.setImage(with: url, placeholder: UIImage(), completionHandler: { _ in
            DispatchQueue.main.async {
                self.addGradientLayer()
                self.imageViews.contentMode = .scaleAspectFill
                self.imageViews.clipsToBounds = true
            }
        })
    }
    
    func addGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = imageViews.bounds

        //그라데이션 색상 설정 (위는 투명, 아래는 검정)
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black!.withAlphaComponent(0.5).cgColor
        ]

        //그라데이션 방향 설정 (위 → 아래)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

        //`imageView`의 `layer`에 추가
        imageViews.layer.addSublayer(gradientLayer)
    }
    
    private func addStack(){
        [gender, line, age].forEach{genderAndAgeStack.addArrangedSubview($0)}
        [nickname, genderAndAgeStack].forEach{nicknameAndInfo.addArrangedSubview($0)}
        [profileImage,nicknameAndInfo].forEach{profileInfo.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [imageView, profileInfo].forEach{addSubview($0)}
    
        imageView.addSubview(imageViews)

        imageView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(-(UIApplication.shared.windows.first?.safeAreaInsets.top)!) //Safe Area 고려하여 확장\
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height * 0.45)
        }
        
        imageViews.snp.makeConstraints {
            $0.edges.equalTo(imageView)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(imageView)
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
    }
}

class OtherPostDetailBottomView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addStack()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var title1 = Label(text: "게시글 제목", font: .ptdSemiBoldFont(ofSize: 17), color: .grey900)
    
    lazy var body = UILabel().then {
        $0.text = "본문 \n"
        $0.font = .ptdRegularFont(ofSize: 15)
        $0.textColor = .grey900
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    lazy var text1 = Label(text: "스크랩 0", font: .ptdRegularFont(ofSize: 12), color: .grey500)
    lazy var text2 = Label(text: "| 채팅 0", font: .ptdRegularFont(ofSize: 12), color: .grey500)
    lazy var text3 = Label(text: "| 조회 0", font: .ptdRegularFont(ofSize: 12), color: .grey500)
    
    private lazy var textStack = Stack(axis: .vertical, spacing: 14)
    lazy var infoStack = Stack(axis: .horizontal, spacing: 10)
    
    private lazy var title2 = Label(text: "동행 정보", font: .ptdSemiBoldFont(ofSize: 17), color: .grey900)
    
    let tableView = UITableView().then {
        $0.register(PostDetailAccompanyCell.self, forCellReuseIdentifier: PostDetailAccompanyCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 36
    }
    
    private func addStack(){
        [title1, body, infoStack].forEach{textStack.addArrangedSubview($0)}
        [text1, text2, text3].forEach{infoStack.addArrangedSubview($0)}
        
    }
    
    private func setupView(){
        [textStack, title2, tableView].forEach{addSubview($0)}
        
        textStack.snp.makeConstraints{
            $0.top.equalToSuperview().inset(8)
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

class OtherPostDetailTapBar: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addStack()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var starImage = UIImageView(image: .star)
    
    private lazy var reviewTitle = Label(text: "후기", font: .ptdSemiBoldFont(ofSize: 13), color: .grey800)
    
    lazy var score1 = Label(text: "5", font: .ptdSemiBoldFont(ofSize: 14), color: .bgcSecondary)
    
    lazy var score2 = Label(text: " /5", font: .ptdSemiBoldFont(ofSize: 14), color: .grey600)
    
    private lazy var line = Label(text: "|", font: .ptdLightFont(ofSize: 38), color: .grey200)
    
    lazy var scrapBtn = UIButton().then {
        $0.setImage(UIImage(systemName: "bookmark"), for: .normal)
        $0.tintColor = .grey800
    }
    
    lazy var chatBtn = UIButton().then {
        $0.setImage(.chatBtn, for: .normal)
    }
    
    lazy var lines = UIView().then {
        $0.backgroundColor = .grey200
    }
    
    private lazy var reviewStack = Stack(axis: .horizontal, spacing: 4)
    private lazy var scoreStack = Stack(axis: .horizontal)
    private lazy var realReviewStack = Stack(axis: .vertical, spacing: 3, alignment: .center)
    private lazy var leftStack = Stack(axis: .horizontal, spacing: 16, distribution: .equalSpacing, alignment: .center)
    
    
    private func addStack() {
        [starImage, reviewTitle].forEach{reviewStack.addArrangedSubview($0)}
        [score1, score2].forEach{scoreStack.addArrangedSubview($0)}
        [reviewStack, scoreStack].forEach{realReviewStack.addArrangedSubview($0)}
        [realReviewStack, line, scrapBtn].forEach{leftStack.addArrangedSubview($0)}
    }
    
    private func setupView() {
        [leftStack, chatBtn, lines].forEach{addSubview($0)}
        
        leftStack.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        starImage.snp.makeConstraints{
            $0.height.width.equalTo(12)
        }
        
        scrapBtn.snp.makeConstraints{
            $0.height.equalTo(27)
            $0.width.equalTo(30)
        }
        
        chatBtn.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(121)
            $0.height.equalTo(44)
        }
        
        lines.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
