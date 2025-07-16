//
//  PostDetailView.swift
//  Duckmelang
//
//  Created by KoNangYeon on 1/14/25.
//
import UIKit
import SnapKit
import Kingfisher

class PostDetailView: UIView {
    
    var imageViewTopConstraint: Constraint!
    var imageViews: [UIImageView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        addStack()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var scrollView = UIScrollView().then {
        $0.scrollsToTop = false
    }
    
    private lazy var contentView = UIView().then {
        $0.backgroundColor = .white
        $0.isUserInteractionEnabled = true
    }
    
    //이미지뷰, 프로필info, 진행중btn
    lazy var postDetailTopView = PostDetailTopView()
    
    lazy var postDetailBottomView = PostDetailBottomView()
    
    lazy var backBtn = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.tintColor = .white
    }
    
    private lazy var title = Label(text: "내 게시글", font: .aritaSemiBoldFont(ofSize: 18), color: .white)
    
    lazy var finishBtn = UIButton().then {
        $0.setImage(.moreVertical, for: .normal)
        $0.tintColor = .white
    }
    
    lazy var setBtnImage = UIImageView().then {
        $0.image = UIImage(resource: .menu1)
        $0.isHidden = true
        $0.isUserInteractionEnabled = true
    }
    
    lazy var imageView = UIScrollView().then {
        $0.backgroundColor = .grey200
        $0.isPagingEnabled = true
    }
    
    let pageControl = UIPageControl().then {
        $0.currentPage = 0
        $0.pageIndicatorTintColor = .lightGray
        $0.currentPageIndicatorTintColor = .black
        $0.hidesForSinglePage = true
    }
    
    lazy var shadowView = UIView().then {
        $0.isUserInteractionEnabled = false
        $0.backgroundColor = .clear
    }

    private lazy var topStack = Stack(axis: .horizontal, distribution: .equalCentering, alignment: .center)
    
    private func addStack(){
        [backBtn, title, finishBtn].forEach{topStack.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [scrollView, shadowView, topStack, setBtnImage].forEach{addSubview($0)}
        [contentView].forEach{scrollView.addSubview($0)}
        [imageView, pageControl, postDetailTopView, postDetailBottomView].forEach{contentView.addSubview($0)}
        
        imageView.snp.makeConstraints{
            imageViewTopConstraint = $0.top.equalTo(contentView.snp.top).constraint
            $0.top.equalTo(safeAreaInsets)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height * 0.45)
            $0.bottom.equalTo(postDetailTopView.snp.top)
        }
        
        shadowView.snp.makeConstraints{
            $0.top.equalTo(safeAreaInsets)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        pageControl.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(imageView.snp.bottom).offset(-8)
        }
        
        topStack.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(42)
        }
        
        scrollView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints{
            $0.top.equalTo(scrollView.frameLayoutGuide.snp.top)
            $0.edges.width.equalToSuperview()
            $0.bottom.equalTo(postDetailBottomView.tableView.snp.bottom).offset(10)
        }
        
        postDetailTopView.snp.makeConstraints{
            $0.top.equalTo(contentView.snp.top).offset(350)
            $0.horizontalEdges.equalToSuperview()
        }
        
        postDetailBottomView.snp.makeConstraints{
            $0.top.equalTo(postDetailTopView.profileInfo.snp.bottom).offset(16)
        }
        
        setBtnImage.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide).inset(26)
            $0.right.equalTo(finishBtn.snp.left).offset(-2.25)
            $0.height.equalTo(80)
            $0.width.equalTo(96)
        }
        
        applyTopInnerShadow(to: shadowView)
    }
    
    // **UI 업데이트 함수**
    func updateUI(with data: MyPostDetailResponse) {
        updateImages(with: data.postImageUrl)
        
        // 상단 프로필 정보 업데이트
        if let userImageUrl = URL(string: data.latestPublicMemberProfileImage ?? "") {
            self.postDetailTopView.profileImage.kf.setImage(with: userImageUrl, placeholder: UIImage())
        }
        postDetailTopView.nickname.text = data.nickname
        postDetailTopView.genderAndAge.text = "\(data.localizedGender)  |  \(data.localizedAge)"
        
        // 하단 게시글 정보 업데이트
        postDetailBottomView.title1.text = data.title
        postDetailBottomView.body.text = data.content
        postDetailBottomView.text1.text = "스크랩 \(data.bookmarkCount)"
        postDetailBottomView.text2.text = "| 채팅 \(data.chatCount)"
        postDetailBottomView.text3.text = "| 조회 \(data.viewCount)"
        
        postDetailBottomView.tableView.reloadData()
    }
    
    func updateImages(with urls: [String]) {
        // 기존 이미지뷰 제거
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews.removeAll()

        var previousImageView: UIImageView?

        for (_, urlStr) in urls.enumerated() {
            guard let url = URL(string: urlStr) else { continue }

            let imageView = UIImageView().then {
                $0.kf.setImage(with: url)
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
            }

            imageView.isUserInteractionEnabled = true

            self.imageView.addSubview(imageView)
            imageViews.append(imageView)

            imageView.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.bottom.equalTo(postDetailTopView.snp.top)
                $0.width.equalToSuperview() // 전체 화면 크기만큼
                $0.height.equalTo(UIScreen.main.bounds.height * 0.45)

                if let previous = previousImageView {
                    $0.leading.equalTo(previous.snp.trailing)
                } else {
                    $0.leading.equalToSuperview()
                }
            }

            previousImageView = imageView
        }

        // 마지막 이미지뷰가 있다면 trailing 설정
        if let lastImageView = imageViews.last {
            lastImageView.snp.makeConstraints {
                $0.trailing.equalToSuperview()
            }
        }

        // 페이지 인디케이터 업데이트
        pageControl.numberOfPages = imageViews.count
        pageControl.currentPage = 0
    }
    
    private func applyTopInnerShadow(to view: UIView) {
        view.layer.sublayers?.removeAll(where: { $0.name == "TopInnerShadow" })

        let shadowLayer = CAGradientLayer()
        shadowLayer.name = "TopInnerShadow"
        shadowLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.width, height: 120)
        shadowLayer.colors = [
            UIColor.black!.withAlphaComponent(0.6).cgColor,
            UIColor.clear.cgColor
        ]
        shadowLayer.startPoint = CGPoint(x: 0, y: 0)
        shadowLayer.endPoint = CGPoint(x: 0, y: 1)

        view.layer.addSublayer(shadowLayer)
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
    
    lazy var profileImage = UIImageView().then {
        $0.image = .profile
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 18
        $0.clipsToBounds = true
    }
    
    lazy var nickname = Label(text: "닉네임", font: .ptdSemiBoldFont(ofSize: 14), color: .black)
    
    lazy var genderAndAge = Label(text: "", font: .ptdRegularFont(ofSize: 13), color: .grey600).then {
        $0.textAlignment = .left
    }
    
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

    lazy var nicknameAndInfo = Stack(axis: .vertical, spacing: 6, alignment: .leading)
    lazy var profileInfo = Stack(axis: .horizontal, spacing: 16, alignment: .center)
    
    
    
    private func addStack(){
        [nickname, genderAndAge].forEach{nicknameAndInfo.addArrangedSubview($0)}
        [profileImage,nicknameAndInfo].forEach{profileInfo.addArrangedSubview($0)}
    }
    
    private func setupView(){
        [profileInfo, progressBtn, progressTapBtn, endBtn].forEach{addSubview($0)}

        profileImage.snp.makeConstraints{
            $0.height.width.equalTo(36)
        }
        
        profileInfo.snp.makeConstraints{
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        progressBtn.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(92)
        }
        
        progressTapBtn.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(92)
        }
        
        endBtn.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
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
            $0.height.greaterThanOrEqualTo(140)
        }
    }
}
